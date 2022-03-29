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
	IsVacant       int       `json:"is_vacant"  db:"is_vacant"`
	IsSupervisor   int       `json:"is_supervisor"  db:"is_supervisor"`
	IsAllocated    int       `json:"is_allocated"  db:"is_allocated"`
	LastUpdated    time.Time `json:"last_updated"  db:"last_updated"`
	AgeRange       string    `json:"age_range"  db:"age_range"`
	ServiceRange   string    `json:"service_range"  db:"service_range"`
	ProfRegCnt     int       `json:"prof_registration_count" db:"prof_registration_count"`
	AdvDegCnt      int       `json:"adv_degree_count" db:"adv_degree_count"`
	CertCnt        int       `json:"certification_count" db:"certification_count"`
	ExpHydrology   int       `json:"expertise_hydrology" db:"expertise_hydrology"`
	ExpHydraulics  int       `json:"expertise_hydraulics" db:"expertise_hydraulics"`
	ExpCoastal     int       `json:"expertise_coastal" db:"expertise_coastal"`
	ExpWM          int       `json:"expertise_wm" db:"expertise_wm"`
	ExpWQ          int       `json:"expertise_wq" db:"expertise_wq"`
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
			service_range,
			prof_registration_count,
			adv_degree_count,
			certification_count,
			expertise_hydrology,
			expertise_hydraulics,
			expertise_coastal,
			expertise_wm,
			expertise_wq
			FROM v_position_report`,
	); err != nil {
		return make([]NormalizedPosition, 0), err
	}
	return pp, nil
}
