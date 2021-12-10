package models

import (
	"context"
	"strings"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Position2 struct {
	ID               string     `json:"id"`
	OfficeSymbol     string     `json:"office_symbol"`
	GroupSlug        string     `json:"group_slug"`
	Title            string     `json:"title"`
	PayPlan          string     `json:"pay_plan"`
	Grade            int        `json:"grade"`
	IsActive         bool       `json:"is_active"`
	IsSupervisor     bool       `json:"is_supervisor"`
	OccupationCode   string     `json:"occupation_code"`
	OccupationName   string     `json:"occupation_name"`
	CurrentOccupancy *Occupancy `json:"current_occupancy"`
}

type Position struct {
	ID             string `json:"id"`
	OfficeSymbol   string `json:"office_symbol" db:"office_symbol"`
	PositionTitle  string `json:"position_title" db:"position_title"`
	Code           string `json:"code" db:"code"`
	Grade          int    `json:"position_grade" db:"grade"`
	IsActive       bool   `json:"is_active" db:"is_active"`
	IsSupervisor   bool   `json:"is_supervisor" db:"is_supervisor"`
	OccupationCode string `json:"occupation_code" db:"occupation_code"`
	OccupationName string `json:"occupation_name" db:"occupation_name"`
	GroupSlug      string `json:"group_slug" db:"group_slug"`
}

// GetOfficeByID
func (p *Position) GetPositionByID(db *pgxpool.Pool, id *uuid.UUID) error {
	rows, err := db.Query(context.Background(),
		`SELECT position_id AS id, office_symbol, position_title, code, grade, is_supervisor, occupation_code, occupation_name, group_slug
		FROM v_office_positions
		WHERE position_id = $1`,
		id,
	)
	if pgxscan.ScanOne(p, rows); err != nil {
		return nil
	}
	return nil
}

// ListPositions lists all positions given an office symbol
func ListPositions(db *pgxpool.Pool, officeSymbol string) ([]Position2, error) {
	pp := make([]Position2, 0)
	if err := pgxscan.Select(
		context.Background(), db, &pp,
		`WITH current_occupancy_by_position as (
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
			   c1.code              as occupation_code,
			   c1.name              as occupation_name,
			   c2.current_occupancy
		FROM position p
		JOIN office_group g on g.id = p.office_group_id AND g.office_id = office_id
		JOIN office f on f.id = g.office_id AND f.id = office_id
		JOIN occupation_code c1 on c1.id = p.occupation_code_id
		JOIN pay_plan a on a.id = p.pay_plan_id
		LEFT JOIN current_occupancy_by_position c2 on c2.position_id = p.id
		WHERE f.symbol ILIKE $1`, officeSymbol,
	); err != nil {
		return make([]Position2, 0), err
	}
	return pp, nil
}

// ListOfficePositions
func ListOfficePositions(db *pgxpool.Pool, office_symbol string, group string, active bool) ([]*Position, error) {
	var ss []*Position
	rows, err := db.Query(context.Background(),
		`SELECT  position_id as id,office_symbol, position_title, code, grade, is_active, is_supervisor, occupation_code, occupation_name, group_slug
		FROM v_office_positions
		WHERE office_symbol = $1
		AND group_slug like $2
		AND is_active = $3
		ORDER BY office_symbol, occupation_code`,
		strings.ToUpper(office_symbol), group, active,
	)
	if err != nil {
		return nil, err
	}
	if err := pgxscan.ScanAll(&ss, rows); err != nil {
		return nil, err
	}
	if len(ss) < 1 {
		return nil, pgx.ErrNoRows
	}
	return ss, nil
}

// CreateOfficePosition
func CreateOfficeGroupPosition(db *pgxpool.Pool, p *Position) (*Position, error) {
	id := new(uuid.UUID)
	if err := db.QueryRow(context.Background(),
		`INSERT INTO position (occupation_code_id, title, office_group_id,
		pay_plan_id, grade, is_supervisor)
		VALUES (
			(SELECT id FROM occupation_code WHERE code = $1),
			$2,
			(SELECT id FROM office_group WHERE office_id = (SELECT id FROM office WHERE symbol = $3) AND slug = $4),
			(SELECT id FROM pay_plan WHERE code = $5),
			$6,
			$7) RETURNING id`,
		p.OccupationCode,
		p.PositionTitle,
		strings.ToUpper(p.OfficeSymbol),
		p.GroupSlug,
		p.Code,
		p.Grade,
		p.IsSupervisor,
	).Scan(&id); err != nil {
		return nil, err
	}
	if err := p.GetPositionByID(db, id); err != nil {
		return nil, err
	}
	return p, nil
}

// UpdateOfficeGroupPosition
func UpdateOfficeGroupPosition(db *pgxpool.Pool, p *Position, id *uuid.UUID) (*Position, error) {
	sqlStatement := `UPDATE position SET
		occupation_code_id = (SELECT id FROM occupation_code WHERE code = $1),
		title = $2,
		office_group_id = (SELECT id FROM office_group WHERE office_id = (SELECT id FROM office WHERE symbol = $3) AND slug = $4),
		pay_plan_id = (SELECT id FROM pay_plan WHERE code = $5),
		grade = $6,
		is_supervisor = $7
		WHERE
			id = $8
				RETURNING id`
	rid := new(uuid.UUID)
	if err := db.QueryRow(context.Background(),
		sqlStatement,
		p.OccupationCode,
		p.PositionTitle,
		strings.ToUpper(p.OfficeSymbol),
		p.GroupSlug,
		p.Code,
		p.Grade,
		p.IsSupervisor,
		id,
	).Scan(&rid); err != nil {
		return nil, err
	}
	p.GetPositionByID(db, rid)
	return p, nil
}

// DeletePosition
func DeletePosition(db *pgxpool.Pool, id *uuid.UUID) (*int64, error) {
	res, err := db.Exec(context.Background(), `DELETE FROM position WHERE id = $1`, id)
	if err != nil {
		return nil, err
	}
	cnt := res.RowsAffected()
	return &cnt, nil
}
