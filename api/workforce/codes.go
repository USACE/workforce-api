package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/labstack/echo/v4"
)

// ListOccupationCodes
func (s Store) ListOccupationCodes(c echo.Context) error {
	soc, err := models.ListOccupationCodes(s.Connection)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, soc)
}
