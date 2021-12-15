package workforce

import (
	"fmt"
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v4"

	"github.com/labstack/echo/v4"
)

// GetPositionByID
func (s Store) GetPositionByID(c echo.Context) error {
	id, _ := uuid.Parse(c.Param("position_id"))
	p, err := models.GetPositionByID(s.Connection, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, p)
		}
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

// ListPositionsByGroup
func (s Store) ListPositionsByGroup(c echo.Context) error {
	pp, err := models.ListPositionsByGroup(s.Connection, c.Param("office_symbol"), c.Param("group_slug"))
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, pp)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, pp)
}

// CreateOfficePosition creates a postion for an office and a particular group
func (s Store) CreateOfficePosition(c echo.Context) error {
	var p models.Position
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	up, err := models.CreateOfficePosition(s.Connection, p)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, up)
}

// UpdateOfficePosition
func (s Store) UpdateOfficePosition(c echo.Context) error {
	var p models.Position
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	up, err := models.UpdateOfficePosition(s.Connection, p)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, up)
}

// DeleteOfficePosition
func (s Store) DeleteOfficePosition(c echo.Context) error {
	id, _ := uuid.Parse(c.Param("position_id"))
	o := c.Param("office_symbol")
	i, err := models.DeleteOfficePosition(s.Connection, id, o)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	if int(i) < 1 {
		return c.JSON(http.StatusOK, messages.NewMessage("no position deleted"))
	}

	return c.JSON(http.StatusOK, messages.NewMessage(fmt.Sprintf("Deleted id %s", id)))

}
