package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Expertise struct {
	ID   uuid.UUID `json:"id"`
	Name string    `json:"name"`
}

// ListExpertise lists all expertise
func ListExpertise(db *pgxpool.Pool) ([]Expertise, error) {
	ee := make([]Expertise, 0)
	if err := pgxscan.Select(
		context.Background(), db, &ee,
		`SELECT id, name FROM expertise`,
	); err != nil {
		return make([]Expertise, 0), err
	}
	return ee, nil
}
