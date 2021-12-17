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
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, oo)
}
