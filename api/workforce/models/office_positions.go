package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Position struct {
	ID               string     `json:"id" param:"position_id"`
	OfficeSymbol     string     `json:"office_symbol" param:"office_symbol"`
	GroupSlug        string     `json:"group_slug" param:"group_slug"`
	Title            string     `json:"title"`
	PayPlan          string     `json:"pay_plan"`
	Grade            int        `json:"grade"`
	IsActive         bool       `json:"is_active"`
	IsSupervisor     bool       `json:"is_supervisor"`
	IsAllocated      bool       `json:"is_allocated"`
	OccupationCode   string     `json:"occupation_code"`
	OccupationName   string     `json:"occupation_name"`
	CurrentOccupancy *Occupancy `json:"current_occupancy"`
}

const baseListPositionSql = `WITH current_occupancy_by_position as (
	SELECT t.position_id, row_to_json(t) as current_occupancy
	FROM (
		SELECT id,
			   position_id,
			   title,
			   start_date::timestamptz,
			   end_date::timestamptz,
			   service_start_date::timestamptz,
			   service_end_date::timestamptz,
			   dob::timestamptz
		FROM occupancy
		WHERE end_date is null
	) t
), office_id AS (SELECT id FROM office WHERE symbol ILIKE $1)
SELECT p.id,
	   f.symbol             as office_symbol,
	   g.slug               as group_slug,
	   p.title,
	   a.code               as pay_plan,
	   p.grade,
	   p.is_active,
	   p.is_supervisor,
	   p.is_allocated,
	   c1.code              as occupation_code,
	   c1.name              as occupation_name,
	   c2.current_occupancy
FROM position p
JOIN office_group g on g.id = p.office_group_id AND g.office_id = office_id
JOIN office f on f.id = g.office_id AND f.id = office_id
JOIN occupation_code c1 on c1.id = p.occupation_code_id
JOIN pay_plan a on a.id = p.pay_plan_id
LEFT JOIN current_occupancy_by_position c2 on c2.position_id = p.id`

// GetPositionByID
func GetPositionByID(db *pgxpool.Pool, id uuid.UUID) (Position, error) {
	var p Position
	if err := pgxscan.Get(context.Background(), db, &p,
		baseListPositionSql+" WHERE p.id = $1::uuid",
		id); err != nil {
		return Position{}, err
	}

	return p, nil
}

// ListPositions lists all positions given an office symbol
func ListPositions(db *pgxpool.Pool, officeSymbol string) ([]Position, error) {
	pp := make([]Position, 0)
	if err := pgxscan.Select(context.Background(), db, &pp,
		baseListPositionSql+" WHERE f.symbol ILIKE $1",
		officeSymbol,
	); err != nil {
		return make([]Position, 0), err
	}
	return pp, nil
}

// ListPositionsByGroup lists all positions given an office symbol and group
func ListPositionsByGroup(db *pgxpool.Pool, officeSymbol string, groupSlug string) ([]Position, error) {
	pp := make([]Position, 0)
	if err := pgxscan.Select(context.Background(), db, &pp,
		baseListPositionSql+" WHERE f.symbol ILIKE $1 AND g.slug = $2",
		officeSymbol, groupSlug,
	); err != nil {
		return pp, err
	}
	return pp, nil
}

// CreateOfficePosition
func CreateOfficePosition(db *pgxpool.Pool, p Position) (Position, error) {
	var id uuid.UUID
	if err := db.QueryRow(context.Background(),
		`INSERT INTO position (occupation_code_id, title, office_group_id, pay_plan_id, grade, is_supervisor, is_active, is_allocated)
		VALUES (
			(SELECT id FROM occupation_code WHERE code = $1),
			$2,
			(SELECT id FROM office_group WHERE office_id = (SELECT id FROM office WHERE symbol ILIKE $3) AND slug = $4),
			(SELECT id FROM pay_plan WHERE code = $5),
			$6, $7, $8, $9) RETURNING id`,
		p.OccupationCode,
		p.Title,
		p.OfficeSymbol,
		p.GroupSlug,
		p.PayPlan,
		p.Grade,
		p.IsSupervisor,
		p.IsActive,
		p.IsAllocated,
	).Scan(&id); err != nil {
		return Position{}, err
	}

	return GetPositionByID(db, id)
}

// UpdatePosition
func UpdateOfficePosition(db *pgxpool.Pool, p Position) (Position, error) {
	var id uuid.UUID
	if err := db.QueryRow(context.Background(),
		`UPDATE position SET
        occupation_code_id = (SELECT id FROM occupation_code WHERE code = $1),
        title = $2,
        office_group_id = (SELECT id FROM office_group WHERE office_id = (SELECT id FROM office WHERE symbol ILIKE $3) AND slug = $4),
        pay_plan_id = (SELECT id FROM pay_plan WHERE code = $5),
        grade = $6,
        is_supervisor = $7,
        is_active = $8,
        is_allocated = $9
        WHERE id = $10
        RETURNING id`,
		p.OccupationCode,
		p.Title,
		p.OfficeSymbol,
		p.GroupSlug,
		p.PayPlan,
		p.Grade,
		p.IsSupervisor,
		p.IsActive,
		p.IsAllocated,
		p.ID,
	).Scan(&id); err != nil {
		return Position{}, err
	}

	return GetPositionByID(db, id)
}

// DeletePosition
func DeleteOfficePosition(db *pgxpool.Pool, id uuid.UUID, officeSymbol string) (int64, error) {
	var cnt int64
	res, err := db.Exec(context.Background(), `DELETE FROM position WHERE id = $1`, id)
	if err != nil {
		return cnt, err
	}
	cnt = res.RowsAffected()
	return cnt, nil
}
