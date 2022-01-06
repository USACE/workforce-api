package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Credentials struct {
	ID           *uuid.UUID `json:"id,omitempty"`
	Abbreviation string     `json:"abbrev,omitempty" db:"abbrev"`
	Name         string     `json:"name,omitempty"`
	Type         string     `json:"type,omitempty"`
}

// GetCredentials
func GetCredentials(db *pgxpool.Pool) ([]Credentials, error) {
	cc := make([]Credentials, 0)
	if err := pgxscan.Select(context.Background(), db, &cc,
		`SELECT c.id, c."abbrev", c."name", ct."name" AS type
		FROM credential AS c, credential_type AS ct
		WHERE ct.id = c.credential_type_id`,
	); err != nil {
		return cc, err
	}
	return cc, nil
}
