package workforce

import (
	"net/http"

	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/labstack/echo/v4"
)


func (s Store) SeriesMetrics(c echo.Context) error {

	var pOfficeSymbol, pGroupSlug *string
	// Office Query Param
	office := c.QueryParam("office")
	if office != "" {
		pOfficeSymbol = &office
	}
	// Group
	group := c.QueryParam("group")
	if group != "" {
		pGroupSlug = &group
	}

	mm, err := models.SeriesMetrics(s.Connection, pOfficeSymbol, pGroupSlug)
	if err != nil {
		return c.String(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, mm)
}