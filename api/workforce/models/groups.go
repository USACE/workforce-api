package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Group struct {
	ID               *uuid.UUID `json:"id,omitempty"`
	OfficeID         *uuid.UUID `json:"office_id,omitempty"`
	UID              string     `json:"uid"`
	OfficeSymbol     string     `json:"office_symbol" param:"office_symbol" db:"office_symbol"`
	Name             string     `json:"name"`
	Slug             string     `json:"slug" param:"group_slug"`
	PositionsAllowed int        `json:"positions_allowed"`
	LastVerified     *time.Time `json:"last_verified" db:"last_verified"`
}

// GetGroupByID
func GetGroupByID(db *pgxpool.Pool, id uuid.UUID) (Group, error) {
	var g Group
	if err := pgxscan.Get(context.Background(), db, &g,
		`SELECT
			og.id,
			og.office_id,
			og.name,
			og.slug,
			og.positions_allowed,
			og.last_verified
		FROM
			office_group AS og
		WHERE
			og.id = $1::uuid`,
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
			f.symbol AS office_symbol, g.name, g.slug, g.positions_allowed, g.last_verified
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
	if err := db.QueryRow(context.Background(),
		`INSERT INTO office_group (office_id, name, slug, positions_allowed) VALUES
		((SELECT id FROM office AS o WHERE o.symbol ILIKE $1), $2, $3, $4) RETURNING id`,
		officeGroup.OfficeSymbol, officeGroup.Name, officeGroup.Slug, officeGroup.PositionsAllowed,
	).Scan(&id); err != nil {
		return Group{}, err
	}
	return GetGroupByID(db, id)

}
