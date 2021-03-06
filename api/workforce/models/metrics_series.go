package models

import (
	"context"
	"fmt"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type SeriesMetric struct {
	OccupationID   uuid.UUID `json:"occupation_id"`
	OccupationCode string    `json:"occupation_code"`
	OccupationName string    `json:"occupation_name"`
	AllocationMetrics
}

func employeesByOccupationPreticate(officeSymbol, groupSlug *string) string {
	if officeSymbol != nil && groupSlug != nil {
		return "WHERE UPPER(f.symbol) = UPPER($1) AND UPPER(g.slug) = UPPER($2)"
	}
	if officeSymbol != nil {
		return "WHERE UPPER(f.symbol) = UPPER($1)"
	}
	return ""
}

func allocationByOccupationPreticate(officeSymbol, groupSlug *string) string {
	if officeSymbol != nil && groupSlug != nil {
		return "WHERE p.is_allocated is TRUE and p.is_active is TRUE AND UPPER(f.symbol) = UPPER($1) AND UPPER(g.slug) = UPPER($2)"
	}
	if officeSymbol != nil {
		return "WHERE p.is_allocated is TRUE AND p.is_active is TRUE AND UPPER(f.symbol) = UPPER($1)"
	}
	return "WHERE p.is_allocated is TRUE AND p.is_active is TRUE"
}

func targetByOccupationPreticate(officeSymbol, groupSlug *string) string {
	if officeSymbol != nil && groupSlug != nil {
		return "WHERE UPPER(f.symbol) = UPPER($1) AND UPPER(g.slug) = UPPER($2) AND p.is_active is TRUE"
	}
	if officeSymbol != nil {
		return "WHERE UPPER(f.symbol) = UPPER($1) AND p.is_active is TRUE"
	}
	return "WHERE p.is_active is TRUE"
}

func SeriesMetrics(db *pgxpool.Pool, officeSymbol, groupSlug *string) ([]SeriesMetric, error) {
	mm := make([]SeriesMetric, 0)

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
		`WITH employees_by_occupation as (
		SELECT oc.id, COUNT(oc.id)
		FROM position p
		JOIN      occupation_code oc on oc.id         = p.occupation_code_id
		JOIN      office_group    g  on g.id          = p.office_group_id
		JOIN      office          f  on f.id          = g.office_id
		JOIN      occupancy       c  on c.position_id = p.id and c.end_date is null
		%s
		group by oc.id
	), allocation_by_occupation as (
		SELECT oc.id, COUNT(oc.id)
		FROM position p
		JOIN      occupation_code oc on oc.id         = p.occupation_code_id
		JOIN      office_group    g  on g.id          = p.office_group_id
		JOIN      office          f  on f.id          = g.office_id
		%s
		group by oc.id
	), target_by_occupation as (
		SELECT oc.id, COUNT(oc.id)
		FROM position p
		JOIN      occupation_code oc on oc.id         = p.occupation_code_id
		JOIN      office_group    g  on g.id          = p.office_group_id
		JOIN      office          f  on f.id          = g.office_id
		%s
		group by oc.id
	)
	select oc.id   AS occupation_id,
		   oc.code AS occupation_code,
		   oc.name AS occupation_name,
		   coalesce(a.count, 0) as employees,
		   coalesce(b.count, 0) as allocated,
		   coalesce(c.count, 0) as target
	from occupation_code oc
	left join employees_by_occupation  a on a.id = oc.id
	left join allocation_by_occupation b on b.id = oc.id
	left join target_by_occupation     c on c.id = oc.id
	where b.count > 0 OR c.count > 0
	order by allocated DESC`,
		employeesByOccupationPreticate(officeSymbol, groupSlug),
		allocationByOccupationPreticate(officeSymbol, groupSlug),
		targetByOccupationPreticate(officeSymbol, groupSlug),
	)

	if err := pgxscan.Select(context.Background(), db, &mm, sql, args(officeSymbol, groupSlug)...); err != nil {
		return make([]SeriesMetric, 0), err
	}
	return mm, nil
}
