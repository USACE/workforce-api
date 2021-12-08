package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/labstack/echo/v4"
)

// ListGroupsByOffice
func (s Store) ListGroupsByOffice(c echo.Context) error {
	sg, err := models.ListGroupsByOffice(s.Connection, c.Param("office_symbol"))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, sg)
}
