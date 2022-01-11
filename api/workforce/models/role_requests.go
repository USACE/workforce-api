package models

import (
	"context"
	"time"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4/pgxpool"
)

type RoleRequest struct {
	ID           uuid.UUID  `json:"id"`
	Sub          uuid.UUID  `json:"sub"`
	OfficeSymbol string     `json:"office_symbol"`
	Status       string     `json:"status"`
	RequestDate  time.Time  `json:"request_date"`
	ResponseDate *time.Time `json:"response_date"`
	Responder    *uuid.UUID `json:"responder"`
}

type CreateRoleRequestResult struct {
	RoleRequest *RoleRequest
	Created     bool
}

const roleRequestSQL = `SELECT r.id,
		                       r.sub,
				               f.symbol AS office_symbol,
				               s.name   AS status,
				               r.request_date,
				               r.response_date,
							   r.responder
						FROM role_request r
						JOIN role_request_status s ON s.id = r.status_id
						JOIN office f ON f.id = r.office_id`

func ListRoleRequests(db *pgxpool.Pool) ([]RoleRequest, error) {
	rr := make([]RoleRequest, 0)
	if err := pgxscan.Select(context.Background(), db, &rr, roleRequestSQL); err != nil {
		return make([]RoleRequest, 0), err
	}
	return rr, nil
}

func ListMyRoleRequests(db *pgxpool.Pool, sub uuid.UUID) ([]RoleRequest, error) {
	rr := make([]RoleRequest, 0)
	if err := pgxscan.Select(
		context.Background(), db, &rr, roleRequestSQL+` WHERE r.sub = $1 ORDER BY f.symbol`, sub,
	); err != nil {
		return make([]RoleRequest, 0), err
	}
	return rr, nil
}

func getRoleRequestByID(db *pgxpool.Pool, id uuid.UUID) (*RoleRequest, error) {
	var r RoleRequest
	if err := pgxscan.Get(
		context.Background(), db, &r, roleRequestSQL+` WHERE r.id = $1`, id,
	); err != nil {
		return nil, err
	}
	return &r, nil
}

func getRoleRequestBySubAndOffice(db *pgxpool.Pool, sub uuid.UUID, officeSymbol string) (*RoleRequest, error) {
	var r RoleRequest
	if err := pgxscan.Get(
		context.Background(), db, &r,
		roleRequestSQL+` WHERE r.sub = $1 AND UPPER(f.symbol) = UPPER($2)`, sub, officeSymbol,
	); err != nil {
		return nil, err
	}
	return &r, nil
}

func CreateRoleRequest(db *pgxpool.Pool, sub uuid.UUID, officeSymbol string) (CreateRoleRequestResult, error) {
	// User's Create Role Request; If role request already exists for provided sub, office,
	// new record is not created and original RoleRequest is returned w/ restful 200
	ctag, err := db.Exec(context.Background(),
		`INSERT INTO role_request (sub, office_id) VALUES
			($1 , (SELECT id FROM office WHERE UPPER(symbol) = UPPER($2) ))
		ON CONFLICT ON CONSTRAINT unique_sub_office DO NOTHING
		`, sub, officeSymbol,
	)
	if err != nil {
		return CreateRoleRequestResult{RoleRequest: nil, Created: false}, err
	}
	r, err := getRoleRequestBySubAndOffice(db, sub, officeSymbol)
	if err != nil {
		return CreateRoleRequestResult{RoleRequest: nil, Created: false}, err
	}
	resp := CreateRoleRequestResult{RoleRequest: r, Created: false}
	if ctag.RowsAffected() > 0 {
		resp.Created = true
	}
	return resp, nil
}

func UpdateRoleRequestStatus(db *pgxpool.Pool, sub uuid.UUID, requestId uuid.UUID, status string) (*RoleRequest, error) {
	var id uuid.UUID
	if err := pgxscan.Get(context.Background(), db, &id,
		`UPDATE role_request
		 SET responder = $1,
		     status_id = (SELECT id FROM role_request_status WHERE name = $2),
			 response_date = CURRENT_TIMESTAMP
		 WHERE id = $3
		 RETURNING id`, sub, status, requestId,
	); err != nil {
		return nil, err
	}
	return getRoleRequestByID(db, id)
}
