package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Office struct {
	ID               uuid.UUID `json:"id"`
	Name             string    `json:"name"`
	Symbol           string    `json:"symbol"`
	PositionsTarget  int       `json:"positions_target"`
	PositionsAllowed int       `json:"positions_allowed"`
	PositionsFilled  int       `json:"positions_filled"`
	ParentOffice
}

// Vacancies      int       `json:"positions_open"`

type ParentOffice struct {
	ID     *uuid.UUID `json:"parent_id" db:"parent_id"`
	Name   string     `json:"parent_name,omitempty" db:"parent_name"`
	Symbol string     `json:"parent_symbol,omitempty" db:"parent_symbol"`
}

func ListOffices(db *pgxpool.Pool) ([]Office, error) {
	oo := make([]Office, 0)
	if err := pgxscan.Select(context.Background(), db, &oo,
		`SELECT
			o.id,
			o.name,
			o.symbol,
			count(o.id) AS positions_filled,
			og.positions_allowed
		FROM
			"position" AS p
		JOIN office_group AS og ON
			og.id = p.office_group_id
		JOIN office AS o ON
			o.id = og.office_id
		JOIN occupancy AS o2 ON
			o2.position_id = p.id
		WHERE
			p.is_active IS TRUE
		GROUP BY o.id, og.positions_allowed`,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
