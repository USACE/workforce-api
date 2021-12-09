package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type OccupationCode struct {
	ID   uuid.UUID `json:"id"`
	Code string    `json:"code"`
	Name string    `json:"name"`
}

// ListOccupationCodes
func ListOccupationCodes(db *pgxpool.Pool) ([]*OccupationCode, error) {
	rows, err := db.Query(context.Background(),
		`SELECT id, code, name FROM occupation_code`,
	)
	if err != nil {
		return nil, err
	}
	soc := make([]*OccupationCode, 0)
	if err = pgxscan.ScanAll(&soc, rows); err != nil {
		return nil, err
	}
	return soc, nil
}
