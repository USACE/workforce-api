package workforce

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"

	"github.com/labstack/echo/v4"
)

// GetPositionByID
func (s Store) GetPositionByID(c echo.Context) error {
	id, err := uuid.Parse(c.Param("position_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	p := new(models.Position)
	if err := p.GetPositionByID(s.Connection, &id); err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, p)
}

// ListPositions lists positions for a single office
func (s Store) ListPositions(c echo.Context) error {
	w, err := models.ListPositions(s.Connection, c.Param("office_symbol"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, w)
}

// ListOfficePositions
func (s Store) ListOfficePositions(c echo.Context) error {
	var a bool = true
	p := c.QueryParam("active")
	if p != "" {
		a, _ = strconv.ParseBool(p)
	}
	w, err := models.ListOfficePositions(s.Connection, c.Param("office_symbol"), "%", a)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, w)
}

// ListOfficeGroupPositions
func (s Store) ListOfficeGroupPositions(c echo.Context) error {
	var a bool = true
	p := c.QueryParam("active")
	if p != "" {
		a, _ = strconv.ParseBool(p)
	}
	j, err := models.ListOfficePositions(s.Connection, c.Param("office_symbol"), c.Param("group"), a)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, j)
}

// CreateOfficePosition
func (s Store) CreateOfficeGroupPosition(c echo.Context) error {
	p := new(models.Position)
	p.OfficeSymbol = c.Param("office_symbol")
	p.GroupSlug = c.Param("group")
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	up, err := models.CreateOfficeGroupPosition(s.Connection, p)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, up)
}

// UpdateOfficeGroupPosition
func (s Store) UpdateOfficeGroupPosition(c echo.Context) error {
	p := new(models.Position)
	p.OfficeSymbol = strings.ToUpper(c.Param("office_symbol"))
	p.GroupSlug = c.Param("group")
	id, err := uuid.Parse(c.Param("position_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	up, err := models.UpdateOfficeGroupPosition(s.Connection, p, &id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, up)
}

// DeletePosition
func (s Store) DeletePosition(c echo.Context) error {
	id, err := uuid.Parse(c.Param("position_id"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	i, err := models.DeletePosition(s.Connection, &id)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	var m messages.Message
	if int(*i) < 1 {
		m = messages.NewMessage("no position deleted")
	} else {
		m = messages.NewMessage(fmt.Sprintf("Deleted id %s", id))
	}
	return c.JSON(http.StatusOK, m)

}
