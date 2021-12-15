package workforce

import (
	"fmt"
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/labstack/echo/v4"
)

// ListGroups
func (s Store) ListGroups(c echo.Context) error {
	sg, err := models.ListGroups(s.Connection)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, sg)
}

// ListGroupsByOffice
func (s Store) ListGroupsByOffice(c echo.Context) error {
	sg, err := models.ListGroupsByOffice(s.Connection, c.Param("office_symbol"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, sg)
}

// CreateOfficeGroup
func (s Store) CreateOfficeGroup(c echo.Context) error {
	var g models.Group
	c.Bind(&g)
	og, err := models.CreateOfficeGroup(s.Connection, g)
	if err != nil {
		return c.JSON(http.StatusBadRequest, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, og)
}

// DeleteOfficeGroup
func (s Store) DeleteOfficeGroup(c echo.Context) error {
	var g models.Group
	c.Bind(&g)
	i, err := models.DeleteOfficeGroup(s.Connection, g)

	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	if int(i) < 1 {
		return c.JSON(http.StatusOK, messages.NewMessage("no position deleted"))
	}

	return c.JSON(http.StatusOK, messages.NewMessage(fmt.Sprintf("Deleted id %s", g.ID)))
}
