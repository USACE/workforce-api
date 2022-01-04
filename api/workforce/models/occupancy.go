package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Occupancy struct {
	ID               uuid.UUID     `json:"id" db:"occupancy_id" param:"occupancy_id"`
	PositionID       uuid.UUID     `json:"position_id"`
	Title            string        `json:"title" db:"occupancy_title"`
	StartDate        *time.Time    `json:"start_date"`
	EndDate          *time.Time    `json:"end_date"`
	ServiceStartDate *time.Time    `json:"service_start_date"`
	ServiceEndDate   *time.Time    `json:"service_end_date"`
	Dob              *time.Time    `json:"dob"`
	Credentials      []Credentials `json:"credentials"`
}

// baseOccupancySql
func baseOccupancySql() string {
	return `WITH office_with_parent as(
			SELECT o.id, o."name", o.symbol AS office_symbol,
			p."name" AS parent_name, p.symbol AS parent_symbol
			FROM office AS o LEFT JOIN office AS p ON o.parent_id = p.id
		),
		occupancy_credentials AS (
			SELECT o.id, json_agg(c.rtj) AS credentials
			FROM occupancy AS o
			LEFT JOIN occupant_credentials AS oc ON o.id = oc.occupancy_id
			LEFT JOIN (
				SELECT id, row_to_json(r) AS rtj
				FROM (SELECT cr.id, cr."abbrev", cr."name", ct."name" AS type
				FROM credential AS cr
				JOIN occupant_credentials AS oc ON oc.credential_id = cr.id
				JOIN credential_type AS ct ON ct.id = cr.credential_type_id
				) AS r
			) AS c ON c.id = oc.credential_id
			GROUP BY o.id
		),
		position_credentials AS (
			SELECT *, o.id AS occupancy_id, o.title AS occupancy_title
			FROM "position" p
			JOIN occupancy o ON p.id = o.position_id
			JOIN occupation_code oc ON p.occupation_code_id = oc.id
			JOIN pay_plan pp ON p.pay_plan_id = pp.id
			JOIN office_group og ON p.office_group_id = og.id
			JOIN office_with_parent AS owp ON owp.id = og.office_id
			JOIN occupancy_credentials AS occ ON occ.id = o.id
			ORDER BY owp.office_symbol, oc.code
			)
		SELECT occupancy_id, position_id, occupancy_title, start_date::timestamptz,
		end_date::timestamptz, service_start_date::timestamptz, service_end_date::timestamptz, dob, credentials
		FROM position_credentials`
}

// GetOccupancyByID with Occupancy as the receiver
func GetOccupancyByID(db *pgxpool.Pool, id uuid.UUID) (Occupancy, error) {
	var o Occupancy
	if err := pgxscan.Get(context.Background(), db, &o,
		baseOccupancySql()+" WHERE occupancy_id = $1", id,
	); err != nil {
		return Occupancy{}, err
	}
	return o, nil
}

// CreateOccupancy
func CreateOccupancy(db *pgxpool.Pool, o Occupancy) (Occupancy, error) {
	var id uuid.UUID
	if err := pgxscan.Get(context.Background(), db, &id,
		`INSERT INTO occupancy
			(position_id, title, start_date, end_date, service_start_date, service_end_date, dob)
		VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
		o.PositionID, o.Title, o.StartDate, o.EndDate, o.ServiceStartDate, o.ServiceEndDate, o.Dob,
	); err != nil {
		return Occupancy{}, err
	}
	return GetOccupancyByID(db, id)
}

// UpdateOccupancy
func UpdateOccupancy(db *pgxpool.Pool, o Occupancy) (Occupancy, error) {
	var id uuid.UUID
	if err := db.QueryRow(context.Background(),
		`UPDATE occupancy SET
		title = $1,
		start_date = $2,
		end_date = $3,
		service_start_date = $4,
		service_end_date = $5,
		dob = $6
		WHERE id = $7 AND
		position_id = $8
		RETURNING id`,
		o.Title, o.StartDate, o.EndDate,
		o.ServiceStartDate, o.ServiceEndDate, o.Dob,
		o.ID, o.PositionID,
	).Scan(&id); err != nil {
		return Occupancy{}, err
	}
	return GetOccupancyByID(db, id)
}

// DeleteOccupancy
// func DeleteOccupancy(db *pgxpool.Pool, id uuid.UUID, positionID uuid.UUID) (int64, error) {
// 	var cnt int64
// 	res, err := db.Exec(context.Background(),
// 		`DELETE FROM occupancy WHERE id = $1 AND position_id = $2`,
// 		id, positionID,
// 	)
// 	if err != nil {
// 		return cnt, err
// 	}
// 	cnt = res.RowsAffected()
// 	return cnt, nil
// }

// ListOccupancy
func ListOccupancyByOffice(db *pgxpool.Pool, officeSymbol string) ([]Occupancy, error) {
	oo := make([]Occupancy, 0)
	if err := pgxscan.Select(context.Background(), db, &oo,
		baseOccupancySql()+" WHERE office_symbol ILIKE $1",
		officeSymbol,
	); err != nil {
		return oo, err
	}
	return oo, nil
}

// ListOccupancyByGroup
func ListOccupancyByGroup(db *pgxpool.Pool, officeSymbol string, groupSlug string) ([]Occupancy, error) {
	oo := make([]Occupancy, 0)
	if err := pgxscan.Select(context.Background(), db, &oo,
		baseOccupancySql()+" WHERE office_symbol ILIKE $1 AND slug = $2",
		officeSymbol, groupSlug,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
