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
		`SELECT id, name, symbol, parent_id FROM office ORDER BY symbol`,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
