package models

import (
	"context"
	"fmt"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type DemographicsMetric struct {
	Label string `json:"label"`
	Value int32  `json:"value"`
}

func byOfficeGroup(officeSymbol, groupSlug *string) string {
	if officeSymbol != nil && groupSlug != nil {
		return "AND UPPER(symbol) = UPPER($1) AND UPPER(slug) = UPPER($2)"
	}
	if officeSymbol != nil {
		return "AND UPPER(symbol) = UPPER($1)"
	}
	return ""
}

func DemographicsMetrics(db *pgxpool.Pool, officeSymbol, groupSlug *string) ([]DemographicsMetric, error) {
	mm := make([]DemographicsMetric, 0)

	args := func(officeSymbol, groupSlug *string) []interface{} {
		if officeSymbol != nil && groupSlug != nil {
			return []interface{}{*officeSymbol, *groupSlug}
		}
		if officeSymbol != nil {
			return []interface{}{*officeSymbol}
		}
		return make([]interface{}, 0)
	}

	sql := fmt.Sprintf(
		`WITH current_occupants as (
			SELECT 
				o.id, 
				o.end_date, 
				o.service_end_date,
				DATE_PART('year', now()) - DATE_PART('year', o.dob) AS age,
				f.symbol AS symbol,
				g.slug AS slug
			FROM occupancy o 
			JOIN "position" p ON p.id = o.position_id
			JOIN office_group g ON g.id = p.office_group_id 
			JOIN office f ON f.id = g.office_id 	
			WHERE is_active IS TRUE
			AND is_allocated IS true
			%s
			)
			SELECT 
			    count(id) AS value,
			    CASE WHEN age < 25 THEN 
			    'Under 25' 
			    WHEN age >= 25 AND age <= 35 THEN
			    '25-35'
			    WHEN age >= 35 AND age <= 45 THEN
			    '35-45'
			    WHEN age >= 45 AND age <= 55 THEN
			    '45-55'
			    ELSE 'Over 55' 
			    END AS label
			FROM current_occupants o
			WHERE (end_date IS NULL OR end_date > NOW())
			AND service_end_date IS NULL OR service_end_date > NOW()
			%s
			GROUP BY label`,
		byOfficeGroup(officeSymbol, groupSlug),
		byOfficeGroup(officeSymbol, groupSlug),
	)

	if err := pgxscan.Select(context.Background(), db, &mm, sql, args(officeSymbol, groupSlug)...); err != nil {
		return make([]DemographicsMetric, 0), err
	}
	return mm, nil
}
