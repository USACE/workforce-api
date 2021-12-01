package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/georgysavva/scany/pgxscan"

	"github.com/USACE/workforce-api/api/workforce/models"

	"github.com/labstack/echo/v4"
)

func (s Store) ListOfficePositions(c echo.Context) error {
	office_symbol := c.Param("office_symbol")
	w, err := models.ListOfficePositions(s.Connection, &office_symbol)
	if err != nil {
		if pgxscan.NotFound(err) {
			return c.JSON(http.StatusNotFound, messages.DefaultMessageNotFound)
		}
		//return c.JSON(http.StatusInternalServerError, messages.DefaultMessageInternalServerError)
		return c.String(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, w)
}
