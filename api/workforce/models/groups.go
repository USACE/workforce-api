package models

import (
	"context"
	"strings"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Group struct {
	OfficeSymbol  string     `json:"office_symbol"`
	Name          string     `json:"name"`
	Slug          string     `json:"slug"`
	Last_verified *time.Time `json:"last_verified"`
}

// ListGroupsByOffice
func ListGroupsByOffice(db *pgxpool.Pool, sym string) ([]*Group, error) {
	sg := make([]*Group, 0)
	rows, err := db.Query(context.Background(),
		`SELECT o1.symbol AS office_symbol, og."name", og.slug, og.last_verified
		FROM office AS o1
		JOIN office AS o2 ON o1.parent_id = o2.id
		JOIN office_group AS og ON o1.id = og.office_id
		WHERE o1.symbol = $1`,
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
