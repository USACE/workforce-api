package models

import "github.com/google/uuid"

type UserInfo struct {
	Sub     uuid.UUID `json:"sub"`
	IsAdmin bool      `json:"is_admin"`
	Roles   []string  `json:"roles"`
}
