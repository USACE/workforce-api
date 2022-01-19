package models

import (
	"context"
	"fmt"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type AgeMetric struct {
	Age   int32 `json:"age"`
	Count int32 `json:"count"`
}

func AgeMetrics(db *pgxpool.Pool, officeSymbol, groupSlug *string) ([]AgeMetric, error) {
	mm := make([]AgeMetric, 0)

	args := func(officeSymbol, groupSlug *string) []interface{} {
		if officeSymbol != nil && groupSlug != nil {
			return []interface{}{*officeSymbol, *groupSlug}
		}
		if officeSymbol != nil {
			return []interface{}{*officeSymbol}
		}
		return make([]interface{}, 0)
	}

	preticate := func(officeSymbol, groupSlug *string) string {
		if officeSymbol != nil && groupSlug != nil {
			return "AND UPPER(f.symbol) = UPPER($1) AND UPPER(g.slug) = UPPER($2)"
		}
		if officeSymbol != nil {
			return "AND UPPER(f.symbol) = UPPER($1)"
		}
		return ""
	}

	if err := pgxscan.Select(
		context.Background(), db, &mm,
		fmt.Sprintf(
			`WITH age_counts as (
				SELECT DATE_PART('year', now()) - DATE_PART('year', o.dob) AS age,
					   count(o.id)
				FROM occupancy o
				JOIN position p ON p.id = o.position_id
				JOIN office_group g ON g.id = p.office_group_id 
				JOIN office f ON f.id = g.office_id 	
				WHERE p.is_active
					AND p.is_allocated
					AND (o.end_date IS NULL OR o.end_date > NOW())
					AND (o.service_end_date IS NULL OR service_end_date > NOW())
					%s
				GROUP BY age
			), bins as (
				SELECT s.a as age
				FROM generate_series(16,90) s(a)
			)
			SELECT b.age,
				   coalesce(ac.count,0) as count
			FROM bins b
			LEFT JOIN age_counts ac on ac.age = b.age`,
			preticate(officeSymbol, groupSlug),
		), args(officeSymbol, groupSlug)...,
	); err != nil {
		return make([]AgeMetric, 0), err
	}
	return mm, nil
}
