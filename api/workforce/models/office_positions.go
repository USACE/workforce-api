package models

import (
	"context"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Position struct {
	OfficeSymbol   string `json:"office_symbol" db:"office_symbol"`
	PositionTitle  string `json:"position_title" db:"position_title"`
	Grade          int    `json:"position_grade" db:"grade"`
	IsSupervisor   *bool  `json:"is_supervisor" db:"is_supervisor"`
	OccupationCode string `json:"occupation_code" db:"occupation_code"`
	OccupationName string `json:"occupation_name" db:"occupation_name"`
}

func ListOfficePositions(db *pgxpool.Pool, office_symbol *string) ([]Position, error) {
	ss := make([]Position, 0)
	if err := pgxscan.Select(
		context.Background(), db, &ss,
		`SELECT office_symbol, position_title, is_supervisor, occupation_code, occupation_name, grade
		 FROM v_office_positions
		 WHERE office_symbol = $1
		 ORDER BY office_symbol`, office_symbol,
	); err != nil {
		return make([]Position, 0), err
	}
	return ss, nil
}
