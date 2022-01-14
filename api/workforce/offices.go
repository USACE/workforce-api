package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/jackc/pgx/v4"

	"github.com/labstack/echo/v4"
)

func (s Store) ListOffices(c echo.Context) error {
	oo, err := models.ListOffices(s.Connection)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.NoContent(http.StatusNoContent)
		}
		return c.JSON(http.StatusInternalServerError, messages.DefaultMessageInternalServerError)
	}
	return c.JSON(http.StatusOK, oo)
}

func (s Store) GetOffice(c echo.Context) error {
	symbol := c.Param("office_symbol")
	if symbol == "" {
		return c.JSON(http.StatusBadRequest, messages.DefaultMessageBadRequest)
	}
	f, err := models.GetOffice(s.Connection, symbol)
	if err != nil {
		if err == pgx.ErrNoRows {
			return c.JSON(http.StatusNoContent, messages.DefaultMessageNotFound)
		}
		return c.JSON(http.StatusInternalServerError, messages.DefaultMessageInternalServerError)
	}
	return c.JSON(http.StatusOK, f)
}
