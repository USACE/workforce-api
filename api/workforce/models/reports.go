package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
)

type NormalizedPosition struct {
	ParentOfficeSymbol string `json:"parent_office_symbol" db:"parent_office_symbol"`
	ParentOfficeName   string `json:"parent_office_name"  db:"parent_office_name"`
	OfficeSymbol       string `json:"office_symbol"  db:"office_symbol"`
	OfficeName         string `json:"office_name"  db:"office_name"`
	GroupName          string `json:"group_name"  db:"group_name"`
	// GroupLastVerified  *time.Time `json:"group_last_verified"  db:"group_last_verified"`
	OccupationCode string    `json:"occupation_code"  db:"occupation_code"`
	OccupationName string    `json:"occupation_name"  db:"occupation_name"`
	Title          string    `json:"title"  db:"title"`
	PayPlanCode    string    `json:"pay_plan_code"  db:"pay_plan_code"`
	TargetGrade    int       `json:"target_grade"  db:"target_grade"`
	PayPlanGrade   string    `json:"pay_plan_grade" db:"pay_plan_grade"`
	IsVacant       bool      `json:"is_vacant"  db:"is_vacant"`
	IsSupervisor   bool      `json:"is_supervisor"  db:"is_supervisor"`
	IsAllocated    bool      `json:"is_allocated"  db:"is_allocated"`
	LastUpdated    time.Time `json:"last_updated"  db:"last_updated"`
	AgeRange       string    `json:"age_range"  db:"age_range"`
	ServiceRange   string    `json:"service_range"  db:"service_range"`
}

// ListNormalizedPositions lists all positions in a normalized view for reporting
func ListNormalizedPositions(db *pgxpool.Pool) ([]NormalizedPosition, error) {
	pp := make([]NormalizedPosition, 0)
	if err := pgxscan.Select(context.Background(), db, &pp,
		`SELECT 
			parent_office_symbol, 
			parent_office_name,
			office_symbol,
			office_name,
			group_name,
			--group_last_verified,
			occupation_code,
			occupation_name,
			title,
			pay_plan_code,
			target_grade,
			pay_plan_grade,
			is_vacant,
			is_supervisor,
			is_allocated,
			last_updated,
			age_range,
			service_range
			FROM v_position_report`,
	); err != nil {
		return make([]NormalizedPosition, 0), err
	}
	return pp, nil
}
