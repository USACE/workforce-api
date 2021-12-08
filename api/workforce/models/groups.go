package models

import (
	"context"
	"strings"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Group struct {
	ID           uuid.UUID  `json:"id"`
	OfficeID     string     `json:"office_id"`
	Name         string     `json:"name"`
	Slug         string     `json:"slug"`
	LastVerified *time.Time `json:"last_verified"`
}

type OfficeGroup struct {
	ID           uuid.UUID    `json:"id"`
	Symbol       string       `json:"symbol"`
	Name         string       `json:"name"`
	GroupIds     []uuid.UUID  `json:"group_ids"`
	GroupNames   []string     `json:"group_names"`
	GroupSlugs   []string     `json:"group_slugs"`
	LastVerified []*time.Time `json:"last_verified"`
}

// ListGroupsByOffice
func ListGroupsByOffice(db *pgxpool.Pool, sym string) (map[string]interface{}, error) {
	rows, err := db.Query(context.Background(),
		`SELECT o1.id AS id, o1.symbol AS symbol,
			json_agg(og.id) AS group_ids,
			json_agg(og."name") AS group_names,
			json_agg(og.slug) AS group_slugs,
			json_agg(og.last_verified) AS last_verified
		FROM office AS o1
		JOIN office AS o2 ON o1.parent_id = o2.id
		JOIN office_group AS og ON o1.id = og.office_id
		WHERE o1.symbol LIKE $1
		GROUP BY o1.id, o1.symbol`,
		strings.ToUpper(sym),
	)
	if err != nil {
		return nil, err
	}
	sog := make([]*OfficeGroup, 0)
	if err = pgxscan.ScanAll(&sog, rows); err != nil {
		return nil, err
	}
	m := make(map[string]interface{})
	for _, v := range sog {
		m[v.Symbol] = v
	}
	return m, nil
}
