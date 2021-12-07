package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type OfficeGroup struct {
	Office
	ID           uuid.UUID  `json:"group_id" db:"group_id"`
	Name         string     `json:"group_name" db:"group_name"`
	Slug         string     `json:"group_slug" db:"group_slug"`
	LastVarified *time.Time `json:"last_verified" db:"last_verified"`
}

// ListGroups
func ListGroups(db *pgxpool.Pool) ([]*OfficeGroup, error) {
	rows, err := db.Query(context.Background(),
		`SELECT
		o1.id,o1."name", o1.symbol,
		o1.parent_id ,o2."name" AS parent_name, o2.symbol AS parent_symbol,
		og.id AS group_id, og."name" AS group_name, og.slug AS group_slug
	FROM
		office AS o1,
		office AS o2,
		office_group AS og
	WHERE
		o1.parent_id = o2.id
		AND 
		o1.id = og.office_id`,
	)
	if err != nil {
		return nil, err
	}
	ogs := make([]*OfficeGroup, 0)
	if err = pgxscan.ScanAll(&ogs, rows); err != nil {
		return nil, err
	}
	return ogs, nil
}
