package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Occupancy struct {
	ID               uuid.UUID  `json:"id" param:"occupancy_id"`
	PositionID       uuid.UUID  `json:"position_id"`
	Title            string     `json:"title"`
	StartDate        *time.Time `json:"start_date"`
	EndDate          *time.Time `json:"end_date"`
	ServiceStartDate *time.Time `json:"service_start_date"`
	ServiceEndDate   *time.Time `json:"service_end_date"`
	Dob              *time.Time `json:"dob"`
}

const baseListOccupancySql = `SELECT id, position_id, title,
start_date, end_date, service_start_date, service_end_date, dob
FROM v_office_occupancy AS v`

// GetOccupancyByID with Occupancy as the receiver
func GetOccupancyByID(db *pgxpool.Pool, id uuid.UUID) (Occupancy, error) {
	var o Occupancy
	if err := pgxscan.Get(context.Background(), db, &o,
		`SELECT o.id, o.position_id, o.title, o.start_date, o.end_date,
		o.service_start_date, o.service_end_date, o.dob
		FROM occupancy AS o
		WHERE id = $1`, id,
	); err != nil {
		return Occupancy{}, nil
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
func UpdateOccupancy(db *pgxpool.Pool, occupancy Occupancy) (Occupancy, error) {
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
		occupancy.Title, occupancy.StartDate, occupancy.EndDate,
		occupancy.ServiceStartDate, occupancy.ServiceEndDate, occupancy.Dob,
		occupancy.ID, occupancy.PositionID,
	).Scan(&id); err != nil {
		return Occupancy{Title: "ERROR"}, nil
	}
	return GetOccupancyByID(db, id)
}

// ListOccupancy
func ListOccupancyByOffice(db *pgxpool.Pool, officeSymbol string) ([]Occupancy, error) {
	oo := make([]Occupancy, 0)
	if err := pgxscan.Select(context.Background(), db, &oo,
		baseListOccupancySql+" WHERE office_symbol ILIKE $1",
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
		baseListOccupancySql+" WHERE v.office_symbol ILIKE $1 AND v.group_slug = $2",
		officeSymbol, groupSlug,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
