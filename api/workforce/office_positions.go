package workforce

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/georgysavva/scany/pgxscan"

	"github.com/USACE/workforce-api/api/workforce/models"

	"github.com/labstack/echo/v4"
)

// GetPositionByID
func (s Store) GetPositionByID(c echo.Context) error {
	p, err := models.GetPositionByID(s.Connection, c.Param("position_id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	return c.JSON(http.StatusOK, p)
}

// ListOfficePositions
func (s Store) ListOfficePositions(c echo.Context) error {
	os := strings.ToUpper(c.Param("office_symbol"))
	w, err := models.ListOfficePositions(s.Connection, os, "%")
	if err != nil {
		if pgxscan.NotFound(err) {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		//return c.JSON(http.StatusInternalServerError, messages.DefaultMessageInternalServerError)
		return c.String(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, w)
}

// ListOfficeGroupPositions
func (s Store) ListOfficeGroupPositions(c echo.Context) error {
	os := c.Param("office_symbol")
	g := c.Param("group")
	j, err := models.ListOfficePositions(s.Connection, os, g)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	return c.JSON(http.StatusOK, j)
}

// CreateOfficePosition
func (s Store) CreateOfficeGroupPosition(c echo.Context) error {
	p := new(models.Position)
	p.OfficeSymbol = strings.ToUpper(c.Param("office_symbol"))
	p.GroupSlug = c.Param("group")
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	up, err := models.CreateOfficeGroupPosition(s.Connection, p)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	return c.JSON(http.StatusOK, up)
}

// UpdateOfficeGroupPosition
func (s Store) UpdateOfficeGroupPosition(c echo.Context) error {
	p := new(models.Position)
	p.OfficeSymbol = strings.ToUpper(c.Param("office_symbol"))
	p.GroupSlug = c.Param("group")
	id := c.Param("position_id")
	if err := c.Bind(&p); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	up, err := models.UpdateOfficeGroupPosition(s.Connection, p, id)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	return c.JSON(http.StatusOK, up)
}

// DeletePosition
func (s Store) DeletePosition(c echo.Context) error {
	id := c.Param("position_id")
	i, err := models.DeletePosition(s.Connection, id)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	m := map[string]string{}
	if i < 1 {
		m["message"] = "Count is 0; no position deleted"
	} else {
		m["message"] = fmt.Sprintf("Deleted id=%s", id)
	}
	return c.JSON(http.StatusOK, m)

}
