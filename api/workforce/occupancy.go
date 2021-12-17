package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/labstack/echo/v4"
)

// CreateOccupancy
func (s Store) CreateOccupancy(c echo.Context) error {
	var co models.Occupancy
	if err := c.Bind(&co); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	o, err := models.CreateOccupancy(s.Connection, co)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, o)
}

// UpdateOccupancy
func (s Store) UpdateOccupancy(c echo.Context) error {
	var o models.Occupancy
	if err := c.Bind(&o); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	oc, err := models.UpdateOccupancy(s.Connection, o)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, oc)
}

// DeleteOccupancy
// func (s Store) DeleteOccupancy(c echo.Context) error {
// 	p := struct {
// 		PositionID uuid.UUID `json:"position_id"`
// 	}{}
// 	id, _ := uuid.Parse(c.Param("occupancy_id"))
// 	c.Bind(&p)
// 	i, err := models.DeleteOccupancy(s.Connection, id, p.PositionID)
// 	if err != nil {
// 		return c.JSON(http.StatusInternalServerError, err)
// 	}
// 	if int(i) < 1 {
// 		return c.JSON(http.StatusOK, messages.NewMessage("no office group deleted"))
// 	}

// 	return c.JSON(http.StatusOK, messages.NewMessage("office group deleted"))
// }

// GetOccupancyByID
func (s Store) GetOccupancyByID(c echo.Context) error {
	id, err := uuid.Parse(c.Param("occupancy_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	o, err := models.GetOccupancyByID(s.Connection, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, o)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, o)
}

//ListOccupancy
func (s Store) ListOccupancyByOffice(c echo.Context) error {
	oo, err := models.ListOccupancyByOffice(s.Connection, c.Param("office_symbol"))
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, oo)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, oo)
}

// ListOccupancyByGroup
func (s Store) ListOccupancyByGroup(c echo.Context) error {
	oo, err := models.ListOccupancyByGroup(s.Connection, c.Param("office_symbol"), c.Param("group_slug"))
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, oo)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, oo)
}
