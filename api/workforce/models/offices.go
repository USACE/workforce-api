package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Office struct {
	ID     uuid.UUID `json:"id"`
	Name   string    `json:"name"`
	Symbol string    `json:"symbol"`
	ParentOffice
}

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
			o."name",
			o.symbol,
			o2.id AS parent_id,
			o2.name AS parent_name,
			o2.symbol AS parent_symbol
		FROM
			office AS o
		JOIN office AS o2 ON
			o2.id = o.parent_id
		ORDER BY o2.symbol, o.symbol`,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
