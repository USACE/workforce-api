package models

import (
	"context"
	"strings"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Position struct {
	OfficeSymbol   string `json:"office_symbol" db:"office_symbol"`
	PositionTitle  string `json:"position_title" db:"position_title"`
	Code           string `json:"code" db:"code"`
	Grade          int    `json:"position_grade" db:"grade"`
	IsSupervisor   bool   `json:"is_supervisor" db:"is_supervisor"`
	OccupationCode string `json:"occupation_code" db:"occupation_code"`
	OccupationName string `json:"occupation_name" db:"occupation_name"`
	GroupSlug      string `json:"group_slug" db:"group_slug"`
}

// GetOfficeByID
func GetPositionByID(db *pgxpool.Pool, id *uuid.UUID) (*Position, error) {
	p := new(Position)
	if err := db.QueryRow(context.Background(),
		`SELECT office_symbol, position_title, code, grade, is_supervisor, occupation_code, occupation_name, group_slug
		FROM v_office_positions
		WHERE position_id = $1`,
		id,
	).Scan(
		&p.OfficeSymbol,
		&p.PositionTitle,
		&p.Code,
		&p.Grade,
		&p.IsSupervisor,
		&p.OccupationCode,
		&p.OccupationName,
		&p.GroupSlug,
	); err != nil {
		return nil, err
	}
	return p, nil
}

// ListOfficePositions
func ListOfficePositions(db *pgxpool.Pool, office_symbol string, group string) ([]*Position, error) {
	var ss []*Position
	rows, err := db.Query(context.Background(),
		`SELECT office_symbol, position_title, code, grade, is_supervisor, occupation_code, occupation_name, group_slug
		FROM v_office_positions
		WHERE office_symbol = $1
		AND group_slug like $2
		ORDER BY office_symbol, occupation_code`,
		strings.ToUpper(office_symbol), group,
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
	sqlStatement := `INSERT INTO position (
		occupation_code_id,
		title,
		office_group_id,
		pay_plan_id,
		grade,
		is_supervisor)
		VALUES (
			(SELECT id FROM occupation_code WHERE code = $1),
			$2,
			(SELECT id FROM office_group WHERE office_id = (SELECT id FROM office WHERE symbol = $3) AND slug = $4),
			(SELECT id FROM pay_plan WHERE code = $5),
			$6,
			$7) RETURNING id`
	id := new(uuid.UUID)
	if err := db.QueryRow(context.Background(),
		sqlStatement,
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
	return GetPositionByID(db, id)
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
	return GetPositionByID(db, rid)
}

// DeletePosition
func DeletePosition(db *pgxpool.Pool, id *uuid.UUID) (*int64, error) {
	// sqlStatement := `WITH deleted AS (DELETE FROM position WHERE id = $1 RETURNING *) SELECT count(*) FROM deleted`
	sqlStatement := `DELETE FROM position WHERE id = $1`
	res, err := db.Exec(context.Background(), sqlStatement, id)
	if err != nil {
		return nil, err
	}
	cnt := res.RowsAffected()
	return &cnt, nil
	// var c int
	// if err := pgxscan.Get(context.Background(), db, &c, sqlStatement, id); err != nil {
	// 	return 0, err
	// }
	// return c, nil
}
