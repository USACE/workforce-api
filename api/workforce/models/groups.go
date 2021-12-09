package models

import (
	"context"
	"strings"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Group struct {
	UID          string     `json:"uid"`
	OfficeSymbol string     `json:"office_symbol" db:"office_symbol"`
	Name         string     `json:"name"`
	Slug         string     `json:"slug"`
	LastVerified *time.Time `json:"last_verified" db:"last_verified"`
}

// ListGroupsByOffice
func ListGroupsByOffice(db *pgxpool.Pool, sym string) ([]*Group, error) {
	sg := make([]*Group, 0)
	rows, err := db.Query(context.Background(),
		`SELECT concat(lower(f.symbol), '-', g.slug) AS uid,
			f.symbol AS office_symbol, g.name, g.slug, g.last_verified
		FROM office_group g
		JOIN office f ON f.id = g.office_id
		WHERE f.symbol = $1`,
		strings.ToUpper(sym),
	)
	if err != nil {
		return nil, err
	}
	if err = pgxscan.ScanAll(&sg, rows); err != nil {
		return nil, err
	}
	return sg, nil
}
