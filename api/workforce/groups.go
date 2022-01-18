package workforce

import (
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

// ListOfficeGroups lists all groups for a single office
func (s Store) ListOfficeGroups(c echo.Context) error {
	sg, err := models.ListOfficeGroups(s.Connection, c.Param("office_symbol"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, sg)
}

// CreateOfficeGroup
func (s Store) CreateOfficeGroup(c echo.Context) error {
	var g models.Group
	if err := c.Bind(&g); err != nil {
		return c.JSON(http.StatusBadRequest, messages.NewMessage(err.Error()))
	}
	og, err := models.CreateOfficeGroup(s.Connection, g)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusCreated, og)
}

// UpdateOfficeGroup
func (s Store) UpdateOfficeGroup(c echo.Context) error {
	var g models.Group
	if err := c.Bind(&g); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}
	og, err := models.UpdateOfficeGroup(s.Connection, g)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, og)
}

// DeleteOfficeGroup
func (s Store) DeleteOfficeGroup(c echo.Context) error {
	o := c.Param("office_symbol")
	g := c.Param("group_slug")
	i, err := models.DeleteOfficeGroup(s.Connection, o, g)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	if int(i) < 1 {
		return c.NoContent(http.StatusNotFound)
	}

	return c.NoContent(http.StatusOK)
}

func (s Store) VerifyOfficeGroup(c echo.Context) error {
	officeSymbol := c.Param("office_symbol")
	groupSlug := c.Param("group_slug")
	userInfo, ok := c.Get("userInfo").(models.UserInfo)
	if !ok {
		return c.JSON(http.StatusForbidden, map[string]string{})
	}
	g, err := models.VerifyOfficeGroup(s.Connection, officeSymbol, groupSlug, userInfo.Sub)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.DefaultMessageInternalServerError)
	}
	return c.JSON(http.StatusCreated, g)
}
