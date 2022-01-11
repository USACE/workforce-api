package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/google/uuid"

	"github.com/labstack/echo/v4"
)

// ListRoleRequests lists all role requests
func (s Store) ListRoleRequests(c echo.Context) error {
	rr, err := models.ListRoleRequests(s.Connection)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, rr)
}

// ListMyRoleRequests lists all role requests for requesting user
func (s Store) ListMyRoleRequests(c echo.Context) error {
	userInfo, ok := c.Get("userInfo").(models.UserInfo)
	if !ok {
		return c.JSON(http.StatusForbidden, map[string]string{})
	}
	rr, err := models.ListMyRoleRequests(s.Connection, userInfo.Sub)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, rr)
}

// CreateRoleRequest lists all role requests
func (s Store) CreateRoleRequest(c echo.Context) error {
	userInfo, ok := c.Get("userInfo").(models.UserInfo)
	if !ok {
		return c.JSON(http.StatusForbidden, map[string]string{})
	}
	r, err := models.CreateRoleRequest(s.Connection, userInfo.Sub, "lrn")
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	// If role request for sub, office_symbol already exists; return a "RESTful 200"
	if !r.Created {
		return c.JSON(http.StatusOK, r.RoleRequest)
	}
	return c.JSON(http.StatusCreated, r.RoleRequest)
}

func (s Store) UpdateRoleRequestStatus(status string) echo.HandlerFunc {
	return func(c echo.Context) error {
		userInfo, ok := c.Get("userInfo").(models.UserInfo)
		if !ok {
			return c.JSON(http.StatusForbidden, map[string]string{})
		}
		id, err := uuid.Parse(c.Param("role_request_id"))
		if err != nil {
			return c.JSON(http.StatusBadRequest, messages.DefaultMessageBadRequest)
		}
		r, err := models.UpdateRoleRequestStatus(s.Connection, userInfo.Sub, id, status)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, err)
		}
		return c.JSON(http.StatusOK, r)
	}
}
