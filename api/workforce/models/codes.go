package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type PayPlan struct {
	ID   uuid.UUID `json:"id"`
	Code string    `json:"code"`
	Name string    `json:"name"`
}

type OccupationCode struct {
	ID   uuid.UUID `json:"id"`
	Code string    `json:"code"`
	Name string    `json:"name"`
}

// ListPayPlanCodes
func ListPayPlanCodes(db *pgxpool.Pool) ([]PayPlan, error) {
	pp := make([]PayPlan, 0)
	rows, err := db.Query(context.Background(),
		`SELECT id, code, name FROM pay_plan`,
	)
	if err != nil {
		return pp, err
	}
	if err = pgxscan.ScanAll(&pp, rows); err != nil {
		return pp, err
	}

	return pp, nil
}

// ListOccupationCodes
func ListOccupationCodes(db *pgxpool.Pool) ([]OccupationCode, error) {
	cc := make([]OccupationCode, 0)
	rows, err := db.Query(context.Background(),
		`SELECT id, code, name FROM occupation_code`,
	)
	if err != nil {
		return nil, err
	}
	if err = pgxscan.ScanAll(&cc, rows); err != nil {
		return nil, err
	}
	return cc, nil
}
