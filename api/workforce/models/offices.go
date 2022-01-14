package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type AllocationMetrics struct {
	Employees *int `json:"employees,omitempty"`
	Allocated *int `json:"allocated,omitempty"`
	Target    *int `json:"target,omitempty"`
}

type Office struct {
	ID           uuid.UUID  `json:"id"`
	Name         string     `json:"name"`
	Symbol       string     `json:"symbol"`
	LastVerified *time.Time `json:"last_verified" db:"last_verified"`
	ParentID     *uuid.UUID `json:"parent_id"`
	AllocationMetrics
}

const sql = `WITH employees_by_office as (
	SELECT f.id, COUNT(f.id)
	FROM position p
	JOIN office_group g ON g.id          = p.office_group_id
	JOIN office       f ON f.id          = g.office_id
	JOIN occupancy    c ON c.position_id = p.id and c.end_date is null
	WHERE p.is_active
	GROUP BY f.id
), allocation_by_office as (
	SELECT f.id, COUNT(f.id)
	FROM position p
	JOIN office_group g ON g.id = p.office_group_id
	JOIN office       f ON f.id = g.office_id
	WHERE p.is_active AND p.is_allocated
	GROUP BY f.id
), target_by_office as (
	SELECT f.id, COUNT(f.id)
	FROM position p
	JOIN office_group g  on g.id = p.office_group_id
	JOIN office       f  on f.id = g.office_id
	WHERE p.is_active
	GROUP BY f.id
), last_verified AS (
	SELECT g.office_id, min(coalesce(last_verified, '1900-01-01')) AS last_verified
	--SELECT g.office_id, last_verified AS last_verified
	FROM office_group g
	JOIN office f on f.id = g.office_id
	GROUP BY g.office_id
)
SELECT o1.id,
	   o1.name,
	   o1.symbol,
	   o2.id                AS parent_id,
	   coalesce(a.count, 0) AS employees,
	   coalesce(b.count, 0) AS allocated,
	   coalesce(c.count, 0) AS target,
	   CASE v.last_verified WHEN '1900-01-01' THEN NULL
	   ELSE v.last_verified
	   END last_verified
FROM office o1
LEFT JOIN employees_by_office  a  ON a.id = o1.id
LEFT JOIN allocation_by_office b  ON b.id = o1.id
LEFT JOIN target_by_office     c  ON c.id = o1.id
LEFT JOIN last_verified        v  ON v.office_id = o1.id
LEFT JOIN office               o2 ON o2.id = o1.parent_id`

func ListOffices(db *pgxpool.Pool) ([]Office, error) {
	ff := make([]Office, 0)
	if err := pgxscan.Select(
		context.Background(), db, &ff, sql+` ORDER BY o2.symbol, o1.symbol`); err != nil {
		return make([]Office, 0), err
	}
	return ff, nil
}

func GetOffice(db *pgxpool.Pool, symbol string) (*Office, error) {
	var f Office
	if err := pgxscan.Get(
		context.Background(), db, &f, sql+` WHERE UPPER(o1.symbol) = UPPER($1)`, symbol,
	); err != nil {
		return nil, err
	}
	return &f, nil
}
