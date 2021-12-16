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
}

// GetGroupByID
func GetGroupByID(db *pgxpool.Pool, id uuid.UUID) (Group, error) {
	var g Group
	if err := pgxscan.Get(context.Background(), db, &g,
		`SELECT
			og.id,
			o.id AS office_id,
			concat(lower(o.symbol), '-', og.slug) as uid,
			o.symbol AS office_symbol,
			og."name",
			og.slug,
			og.last_verified
		FROM
			office AS o
		JOIN office_group AS og ON
			og.office_id = o.id
		WHERE og.id = $1::uuid`,
		id); err != nil {
		return Group{}, err
	}

	return g, nil
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

// ListGroupsByOffice
func ListGroupsByOffice(db *pgxpool.Pool, sym string) ([]Group, error) {
	gg := make([]Group, 0)
	rows, err := db.Query(context.Background(),
		`SELECT concat(lower(f.symbol), '-', g.slug) AS uid,
			f.symbol AS office_symbol, g.name, g.slug, g.last_verified
		FROM office_group g
		JOIN office f ON f.id = g.office_id
		WHERE f.symbol ILIKE $1`,
		sym,
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
func CreateOfficeGroup(db *pgxpool.Pool, officeGroup Group) (Group, error) {
	var id uuid.UUID
	officeGroup.Slug = slugify.Slugify(officeGroup.Name)
	if err := db.QueryRow(context.Background(),
		`INSERT INTO office_group (office_id, name, slug) VALUES
		((SELECT id FROM office AS o WHERE o.symbol ILIKE $1), $2, $3) RETURNING id`,
		officeGroup.OfficeSymbol, officeGroup.Name, officeGroup.Slug,
	).Scan(&id); err != nil {
		return Group{}, err
	}
	return GetGroupByID(db, id)

}

// UpdateOfficeGroup
func UpdateOfficeGroup(db *pgxpool.Pool, officeGroup Group) (Group, error) {
	var id uuid.UUID
	if err := db.QueryRow(context.Background(),
		`UPDATE office_group SET
		name = $1
		WHERE id = $2 AND
		office_id = (SELECT id FROM office WHERE symbol ILIKE $3)
		RETURNING id`,
		officeGroup.Name, officeGroup.ID, officeGroup.OfficeSymbol,
	).Scan(&id); err != nil {
		return Group{Name: "NO NEW NAME"}, nil
	}
	return GetGroupByID(db, id)
}

// DeleteOfficeGroup
func DeleteOfficeGroup(db *pgxpool.Pool, officeGroup Group) (int64, error) {
	var cnt int64
	res, err := db.Exec(context.Background(),
		`DELETE FROM office_group AS og
		WHERE office_id = (SELECT id FROM office AS o WHERE o.symbol ILIKE $1)
		AND og.id = $2`,
		officeGroup.OfficeSymbol, officeGroup.ID,
	)
	if err != nil {
		return cnt, err
	}
	cnt = res.RowsAffected()
	return cnt, nil
}
