package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type Occupancy struct {
	ID               uuid.UUID  `json:"id" db:"occupancy_id" param:"occupancy_id"`
	PositionID       uuid.UUID  `json:"position_id"`
	Title            string     `json:"title" db:"occupancy_title"`
	StartDate        *time.Time `json:"start_date"`
	EndDate          *time.Time `json:"end_date"`
	ServiceStartDate *time.Time `json:"service_start_date"`
	ServiceEndDate   *time.Time `json:"service_end_date"`
	Dob              *time.Time `json:"dob"`
	Credentials      []string   `json:"credentials"`
}

// baseOccupancySql
func baseOccupancySql() string {
	return `WITH occupancy_credentials AS (
		SELECT o.id AS occupancy_id, p.id AS position_id, o.title AS occupancy_title,
			o.start_date, o.end_date, o.service_start_date, o.service_end_date, o.dob, json_agg(r."abbrev") AS credentials,
			og.slug, f.symbol
		FROM "position" p
		JOIN occupancy o ON o.position_id = p.id
		JOIN occupation_code oc ON oc.id = p.occupation_code_id
		JOIN office_group AS og ON og.id = p.office_group_id
		JOIN office AS f ON f.id = og.office_id
		LEFT JOIN (SELECT oc.occupancy_id, c."abbrev"
				FROM occupant_credentials AS oc
				JOIN credential AS c ON c.id = oc.credential_id
				) AS r ON r.occupancy_id = o.id
		GROUP BY o.id, p.id, og.slug, f.symbol
	)
	SELECT oc.occupancy_id, oc.position_id, oc.occupancy_title,
		oc.start_date, oc.end_date, oc.service_start_date, oc.service_end_date,
		oc.dob, oc.credentials
	FROM occupancy_credentials AS oc`
}

// diff finds the difference between a and b.
// Return a slice of what's in a but not in b
func difference(a, b []string) []string {
	mb := make(map[string]struct{}, len(b))
	for _, x := range b {
		mb[x] = struct{}{}
	}
	var diff []string
	for _, x := range a {
		if _, found := mb[x]; !found {
			diff = append(diff, x)
		}
	}
	return diff
}

// GetOccupancyByID with Occupancy as the receiver
func GetOccupancyByID(db *pgxpool.Pool, id uuid.UUID) (Occupancy, error) {
	var o Occupancy
	if err := pgxscan.Get(context.Background(), db, &o,
		baseOccupancySql()+" WHERE oc.occupancy_id = $1", id,
	); err != nil {
		return Occupancy{}, err
	}
	return o, nil
}

// CreateOccupancy
func CreateOccupancy(db *pgxpool.Pool, o Occupancy) (Occupancy, error) {
	var id uuid.UUID
	ctx := context.Background()

	// Get a Tx for making transaction requests.
	tx, err := db.Begin(ctx)
	if err != nil {
		return Occupancy{}, err
	}

	// Defer a rollback in case anything fails.
	defer tx.Rollback(ctx)

	// Create a new row in the occupancy table.
	if err := tx.QueryRow(ctx,
		`INSERT INTO occupancy
			(position_id, title, start_date, end_date, service_start_date, service_end_date, dob)
			VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id`,
		o.PositionID, o.Title, o.StartDate, o.EndDate, o.ServiceStartDate, o.ServiceEndDate, o.Dob,
	).Scan(&id); err != nil {
		return Occupancy{}, err
	}
	// Create a new row in occupancy_credentials for each credential in the payload.
	for _, c := range o.Credentials {
		if _, err = tx.Exec(ctx,
			`INSERT INTO occupant_credentials (occupancy_id, credential_id)
				VALUES ($1, (SELECT id FROM credential AS c WHERE c."abbrev" ILIKE $2))`,
			id, c,
		); err != nil {
			return Occupancy{}, err
		}
	}

	// Commit the transaction.
	if err = tx.Commit(ctx); err != nil {
		return Occupancy{}, err
	}

	return GetOccupancyByID(db, id)
}

// UpdateOccupancy
func UpdateOccupancy(db *pgxpool.Pool, o Occupancy) (Occupancy, error) {
	// Get a Tx for making transaction requests.
	ctx := context.Background()
	tx, err := db.Begin(ctx)
	if err != nil {
		return Occupancy{}, err
	}

	// Defer a rollback in case anything fails.
	defer tx.Rollback(ctx)

	// Update the occupancy table
	if _, err = tx.Exec(ctx,
		`UPDATE occupancy SET title = $1, start_date = $2, end_date = $3,
		service_start_date = $4, service_end_date = $5, dob = $6
		WHERE id = $7 AND position_id = $8`,
		o.Title, o.StartDate, o.EndDate,
		o.ServiceStartDate, o.ServiceEndDate, o.Dob,
		o.ID, o.PositionID,
	); err != nil {
		return Occupancy{}, err
	}

	// a is the list of credentials as []string
	a := o.Credentials

	// select the occupancy credentials returning and array of credential abbreviations
	var b []string
	if err = tx.QueryRow(ctx,
		`SELECT json_agg(c."abbrev")
		FROM occupant_credentials AS oc JOIN credential AS c ON c.id = oc.credential_id
		WHERE occupancy_id = $1`,
		o.ID,
	).Scan(&b); err != nil {
		return Occupancy{}, err
	}
	// take the difference getting what needs to be deleted and what needs inserted
	toDelete := difference(b, a)
	toInsert := difference(a, b)

	// What needs to be deleted
	for _, ba := range toDelete {
		if _, err = tx.Exec(ctx,
			`DELETE FROM occupant_credentials AS oc
		WHERE oc.occupancy_id = $1 AND
		oc.credential_id = (SELECT id FROM credential AS c WHERE c."abbrev" ILIKE $2)`,
			o.ID, ba,
		); err != nil {
			return Occupancy{}, err
		}
	}

	// What needs to be inserted
	for _, ab := range toInsert {
		if _, err = tx.Exec(ctx,
			`INSERT INTO occupant_credentials (occupancy_id, credential_id)
				VALUES ($1, (SELECT id FROM credential AS c WHERE c."abbrev" ILIKE $2))`,
			o.ID, ab,
		); err != nil {
			return Occupancy{}, err
		}
	}

	// Commit the transaction.
	if err = tx.Commit(ctx); err != nil {
		return Occupancy{}, err
	}

	return GetOccupancyByID(db, o.ID)
}

// ListOccupancy
func ListOccupancyByOffice(db *pgxpool.Pool, officeSymbol string) ([]Occupancy, error) {
	oo := make([]Occupancy, 0)
	if err := pgxscan.Select(context.Background(), db, &oo,
		baseOccupancySql()+" WHERE oc.symbol ILIKE $1",
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
		baseOccupancySql()+" WHERE oc.symbol ILIKE $1 AND oc.slug = $2",
		officeSymbol, groupSlug,
	); err != nil {
		return oo, err
	}
	return oo, nil
}
