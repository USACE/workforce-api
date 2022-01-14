package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/mozillazg/go-slugify"
)

type Group struct {
	ID           *uuid.UUID `json:"id,omitempty" param:"group_id"`
	OfficeID     *uuid.UUID `json:"office_id,omitempty"`
	UID          string     `json:"uid"`
	OfficeSymbol string     `json:"office_symbol" param:"office_symbol" db:"office_symbol"`
	Name         string     `json:"name"`
	Slug         string     `json:"slug" param:"group_slug"`
	LastVerified *time.Time `json:"last_verified" db:"last_verified"`
	AllocationMetrics
}

// GetGroupByID
func GetGroupByID(db *pgxpool.Pool, id uuid.UUID) (*Group, error) {
	var g Group
	if err := pgxscan.Get(context.Background(), db, &g,
		`WITH employees_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g ON g.id = p.office_group_id
			JOIN occupancy    c ON c.position_id = p.id and c.end_date is null
			WHERE p.is_active AND g.id = $1
			GROUP BY g.id
		), allocation_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g ON g.id = p.office_group_id
			WHERE p.is_active AND g.id = $1
			GROUP BY g.id
		), target_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g  on g.id = p.office_group_id
			WHERE p.is_active AND g.id = $1
			GROUP BY g.id
		)
		SELECT concat(lower(f.symbol), '-', g.slug) AS uid,
		       f.symbol                             AS office_symbol,
			   g.name, 
			   g.slug,
			   g.last_verified,
			   coalesce(a.count, 0)                 AS employees,
			   coalesce(b.count, 0)                 AS allocated,
			   coalesce(c.count, 0)                 AS target
		FROM office_group g
		JOIN office                   f ON f.id = g.office_id
		LEFT JOIN employees_by_group  a ON a.id = g.id
		LEFT JOIN allocation_by_group b ON b.id = g.id
		LEFT JOIN target_by_group     c ON c.id = g.id
		WHERE g.id = $1`, id); err != nil {
		return nil, err
	}
	return &g, nil
}

// ListGroups
func ListGroups(db *pgxpool.Pool) ([]Group, error) {
	gg := make([]Group, 0)
	rows, err := db.Query(context.Background(),
		`SELECT g.id, concat(lower(f.symbol), '-', g.slug) AS uid,
			f.symbol AS office_symbol, g.name, g.slug, g.last_verified
		FROM office_group g
		JOIN office f ON f.id = g.office_id`,
	)
	if err != nil {
		return gg, err
	}
	if err = pgxscan.ScanAll(&gg, rows); err != nil {
		return gg, err
	}
	return gg, nil
}

// ListOfficeGroups lists all groups for a single office
func ListOfficeGroups(db *pgxpool.Pool, officeSymbol string) ([]Group, error) {
	gg := make([]Group, 0)
	rows, err := db.Query(
		context.Background(),
		`WITH employees_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g ON g.id = p.office_group_id
			JOIN occupancy    c ON c.position_id = p.id and c.end_date is null
			WHERE p.is_active AND g.office_id IN (SELECT id FROM office WHERE UPPER(symbol) = UPPER($1))
			GROUP BY g.id
		), allocation_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g ON g.id = p.office_group_id
			WHERE p.is_active AND g.office_id IN (SELECT id FROM office WHERE UPPER(symbol) = UPPER($1))
			GROUP BY g.id
		), target_by_group as (
			SELECT g.id, COUNT(g.id)
			FROM position p
			JOIN office_group g  on g.id = p.office_group_id
			WHERE p.is_active AND g.office_id IN (SELEcT id FROM office WHERE UPPER(symbol) = UPPER($1))
			GROUP BY g.id
		)
		SELECT concat(lower(f.symbol), '-', g.slug) AS uid,
		       f.symbol                             AS office_symbol,
			   g.name, 
			   g.slug,
			   g.last_verified,
			   coalesce(a.count, 0)                 AS employees,
			   coalesce(b.count, 0)                 AS allocated,
			   coalesce(c.count, 0)                 AS target
		FROM office_group g
		JOIN office                   f ON f.id = g.office_id
		LEFT JOIN employees_by_group  a ON a.id = g.id
		LEFT JOIN allocation_by_group b ON b.id = g.id
		LEFT JOIN target_by_group     c ON c.id = g.id
		WHERE UPPER(f.symbol) = UPPER($1)`,
		officeSymbol,
	)
	if err != nil {
		return nil, err
	}
	if err = pgxscan.ScanAll(&gg, rows); err != nil {
		return nil, err
	}
	return gg, nil
}

// CreateOfficeGroup
func CreateOfficeGroup(db *pgxpool.Pool, officeGroup Group) (*Group, error) {
	var id uuid.UUID
	officeGroup.Slug = slugify.Slugify(officeGroup.Name)
	if err := db.QueryRow(context.Background(),
		`INSERT INTO office_group (office_id, name, slug) VALUES
			((SELECT id FROM office WHERE UPPER(symbol) = UPPER($1)), $2, $3)
		RETURNING id`,
		officeGroup.OfficeSymbol, officeGroup.Name, officeGroup.Slug,
	).Scan(&id); err != nil {
		return nil, err
	}
	return GetGroupByID(db, id)

}

// UpdateOfficeGroup
func UpdateOfficeGroup(db *pgxpool.Pool, officeGroup Group) (*Group, error) {
	var id uuid.UUID
	if err := db.QueryRow(context.Background(),
		`UPDATE office_group SET name = $1
		WHERE slug = $2 AND office_id = (SELECT id FROM office WHERE UPPER(symbol) = UPPER($3))
		RETURNING id`,
		officeGroup.Name, officeGroup.Slug, officeGroup.OfficeSymbol,
	).Scan(&id); err != nil {
		return nil, err
	}
	return GetGroupByID(db, id)
}

// DeleteOfficeGroup
func DeleteOfficeGroup(db *pgxpool.Pool, office string, group string) (int64, error) {
	var cnt int64
	res, err := db.Exec(context.Background(),
		`DELETE FROM office_group
		WHERE office_id = (SELECT id FROM office WHERE UPPER(symbol) = UPPER($1))
			AND UPPER(slug) = UPPER($2)`, office, group,
	)
	if err != nil {
		return cnt, err
	}
	cnt = res.RowsAffected()
	return cnt, nil
}

func VerifyOfficeGroup(db *pgxpool.Pool, office string, group string, sub uuid.UUID) (*Group, error) {
	var id uuid.UUID
	if err := pgxscan.Get(
		context.Background(), db, &id,
		`UPDATE office_group SET last_verified = CURRENT_TIMESTAMP, last_verified_by = $3
		 WHERE office_id = (SELECT id FROM office WHERE UPPER(symbol) = UPPER($1))
		 	AND UPPER(slug) = UPPER($2)
		 RETURNING id`, office, group, sub,
	); err != nil {
		return nil, err
	}
	return GetGroupByID(db, id)
}
