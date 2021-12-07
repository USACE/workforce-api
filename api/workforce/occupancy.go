package workforce

import (
	"net/http"
	"strconv"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"
	"github.com/labstack/echo/v4"
)

// CreateOccupancy
func (s Store) CreateOccupancy(c echo.Context) error {
	o := new(models.Occupancy)
	if err := c.Bind(o); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	co, err := models.CreateOccupancy(s.Connection, o)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, co)
}

// GetOccupancyByID
func (s Store) GetOccupancyByID(c echo.Context) error {
	id, err := uuid.Parse(c.Param("occupancy_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	o := new(models.Occupancy)
	o.ID = id
	if err := o.GetOccupancyByID(s.Connection); err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, o)
}

//ListOfficeOccupancy
func (s Store) ListOfficeOccupancy(c echo.Context) error {
	var a bool = true
	p := c.QueryParam("active")
	if p != "" {
		a, _ = strconv.ParseBool(p)
	}
	w, err := models.ListOfficeOccupancy(s.Connection, c.Param("office_symbol"), "%", a)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, w)
}

//ListOfficeGroupOccupancy
func (s Store) ListOfficeGroupOccupancy(c echo.Context) error {
	var a bool = true
	p := c.QueryParam("active")
	if p != "" {
		a, _ = strconv.ParseBool(p)
	}
	so, err := models.ListOfficeOccupancy(s.Connection, c.Param("office_symbol"), c.Param("group"), a)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, so)
}
