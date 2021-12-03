package models

import (
	"context"
	"strings"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Position struct {
	OfficeSymbol   string `json:"office_symbol" db:"office_symbol"`
	PositionTitle  string `json:"position_title" db:"position_title"`
	Code           string `json:"code" db:"code"`
	Grade          int    `json:"position_grade" db:"grade"`
	IsSupervisor   *bool  `json:"is_supervisor" db:"is_supervisor"`
	OccupationCode string `json:"occupation_code" db:"occupation_code"`
	OccupationName string `json:"occupation_name" db:"occupation_name"`
	GroupSlug      string `json:"group_slug" db:"group_slug"`
}

// GetOfficeByID
func GetPositionByID(db *pgxpool.Pool, id string) (*Position, error) {
	ps := []Position{}
	if err := pgxscan.Select(context.Background(),
		db, &ps,
		`SELECT office_symbol, position_title, code, grade, is_supervisor, occupation_code, occupation_name, group_slug
		 FROM v_office_positions
		 WHERE position_id = $1`,
		id,
	); err != nil {
		return nil, err
	}
	p := &ps[0]
	return p, nil
}
func ListOfficePositions(db *pgxpool.Pool, office_symbol string, group string) ([]Position, error) {
	ss := make([]Position, 0)
	if err := pgxscan.Select(
		context.Background(), db, &ss,
		`SELECT office_symbol, position_title, code, grade, is_supervisor, occupation_code, occupation_name, group_slug
		 FROM v_office_positions
		 WHERE office_symbol = $1
		 AND group_slug like $2
		 ORDER BY office_symbol`, strings.ToUpper(office_symbol), group,
	); err != nil {
		return nil, err
	}
	return ss, nil
}

// CreateOfficePosition
func CreateOfficeGroupPosition(db *pgxpool.Pool, p *Position) (*Position, error) {
	tx, err := db.Begin(context.Background())
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(context.Background())
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
	db.QueryRow(context.Background(),
		sqlStatement,
		p.OccupationCode,
		p.PositionTitle,
		p.OfficeSymbol,
		p.GroupSlug,
		p.Code,
		p.Grade,
		p.IsSupervisor,
	).Scan(&id)
	if err = tx.Commit(context.Background()); err != nil {
		return nil, err
	}

	return GetPositionByID(db, id.String())
}

// UpdateOfficeGroupPosition
func UpdateOfficeGroupPosition(db *pgxpool.Pool, p *Position, id string) (*Position, error) {
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
	if err := pgxscan.Get(context.Background(), db, &rid,
		sqlStatement,
		p.OccupationCode,
		p.PositionTitle,
		p.OfficeSymbol,
		p.GroupSlug,
		p.Code,
		p.Grade,
		p.IsSupervisor,
		id,
	); err != nil {
		return nil, err
	}
	return GetPositionByID(db, rid.String())
}

// DeletePosition
func DeletePosition(db *pgxpool.Pool, id string) (int, error) {
	sqlStatement := `WITH deleted AS (DELETE FROM position WHERE id = $1 RETURNING *) SELECT count(*) FROM deleted`
	var c int
	if err := pgxscan.Get(context.Background(), db, &c, sqlStatement, id); err != nil {
		return 0, err
	}
	return c, nil
}
