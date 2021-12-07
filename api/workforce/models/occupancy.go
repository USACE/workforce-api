package models

import (
	"context"
	"strings"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Occupancy struct {
	ID               uuid.UUID  `json:"id"`
	PositionID       uuid.UUID  `json:"position_id"`
	Title            *string    `json:"title"`
	StartDate        *time.Time `json:"start_date"`
	EndDate          *time.Time `json:"end_date"`
	ServiceStartDate *time.Time `json:"service_start_date"`
	ServiceEndDate   *time.Time `json:"service_end_date"`
	Dob              *time.Time `json:"dob"`
}

// CreateOccupancy
func CreateOccupancy(db *pgxpool.Pool, o *Occupancy) (*Occupancy, error) {
	id := new(uuid.UUID)
	if err := db.QueryRow(
		context.Background(),
		`INSERT INTO occupancy
			(position_id, title, start_date, end_date, service_start_date, service_end_date, dob)
		VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
		o.PositionID, o.Title, o.StartDate, o.EndDate, o.ServiceStartDate, o.ServiceEndDate, o.Dob,
	).Scan(id); err != nil {
		return nil, err
	}
	o.ID = *id
	o.GetOccupancyByID(db)
	return o, nil
}

// GetOccupancyByID with Occupancy as the receiver
func (o *Occupancy) GetOccupancyByID(db *pgxpool.Pool) error {
	if err := db.QueryRow(
		context.Background(),
		`SELECT o.id, o.position_id, o.title, o.start_date, o.end_date,
		o.service_start_date, o.service_end_date, o.dob
		FROM occupancy AS o
		WHERE id = $1`, o.ID,
	).Scan(
		&o.ID,
		&o.PositionID,
		&o.Title,
		&o.StartDate,
		&o.EndDate,
		&o.ServiceStartDate,
		&o.ServiceEndDate,
		&o.Dob,
	); err != nil {
		return err
	}
	return nil
}

//ListOfficeOccupancy
func ListOfficeOccupancy(db *pgxpool.Pool, office_symbol string, group string, active bool) ([]*Occupancy, error) {
	so := make([]*Occupancy, 0)
	rows, err := db.Query(
		context.Background(),
		`SELECT id, position_id, title, start_date, end_date, service_start_date, service_end_date, dob
		FROM v_office_occupancy AS voo
		WHERE office_symbol = $1 AND group_slug LIKE $2 AND is_active = $3
		ORDER BY office_symbol, occupation_code`,
		strings.ToUpper(office_symbol), group, active,
	)
	if err != nil {
		return nil, err
	}
	if err = pgxscan.ScanAll(&so, rows); err != nil {
		return nil, err
	}
	if len(so) < 1 {
		return nil, pgx.ErrNoRows
	}

	return so, nil
}
