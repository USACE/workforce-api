package main

import (
	"log"
	"net/http"
	"time"

	"golang.org/x/net/http2"

	"github.com/USACE/workforce-api/api/app"
	"github.com/USACE/workforce-api/api/middleware"
	"github.com/USACE/workforce-api/api/workforce"

	_ "github.com/jackc/pgx/v4"
	"github.com/kelseyhightower/envconfig"
	"github.com/labstack/echo/v4"
)

func main() {

	// parse configuration from environment variables
	var config app.Config
	if err := envconfig.Process("workforce", &config); err != nil {
		log.Fatal(err.Error())
	}
	// create store (database pool) from configuration
	st, err := app.NewStore(config)
	if err != nil {
		log.Fatal(err.Error())
	}

	e := echo.New()                         // All Routes
	e.Use(middleware.CORS, middleware.GZIP) // All Routes Middleware

	// Public Routes
	public := e.Group("")

	// Private Routes w/ Access Control
	private := e.Group("")
	if config.AuthMocked {
		// @todo. re-add JWTMock
		// private.Use(middleware.JWTMock)
		log.Println("Auth is Disabled...")
	} else {
		private.Use(middleware.JWT, middleware.AttachUserInfo)
	}

	// App Routes (Intended to be used by application only)
	key := e.Group("")
	key.Use(middleware.KeyAuth(config.ApplicationKey))

	// Health Check
	public.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{"status": "healthy"})
	})

	/////////////////////////////////////////////////////////////////////////////
	// Manpower
	/////////////////////////////////////////////////////////////////////////////
	// Manpower Store
	mp := workforce.Store{Connection: st.Connection}

	// Codes
	public.GET("/occupation_codes", mp.ListOccupationCodes)
	public.GET("/pay_plans", mp.ListPayPlanCodes)

	// Offices
	public.GET("/offices", mp.ListOffices)

	// Positions
	public.GET("/position/:position_id", mp.GetPositionByID)
	key.DELETE("/position/:position_id", mp.DeletePosition)

	// Groups
	public.GET("/groups", mp.ListGroups)
	public.GET("/offices/:office_symbol/groups", mp.ListGroupsByOffice)

	// Office Positions/Employees
	public.GET("/offices/:office_symbol/positions", mp.ListOfficePositions)
	public.GET("/offices/:office_symbol/:group/positions", mp.ListOfficeGroupPositions)
	key.POST("/offices/:office_symbol/:group/positions", mp.CreateOfficeGroupPosition)
	key.PUT("/offices/:office_symbol/:group/positions/:position_id", mp.UpdateOfficeGroupPosition)

	// Occupancy
	key.POST("/occupancy", mp.CreateOccupancy)
	public.GET("/occupancy/:occupancy_id", mp.GetOccupancyByID)
	public.GET("/offices/:office_symbol/occupancy", mp.ListOfficeOccupancy)
	public.GET("offices/:office_symbol/:group/occupancy", mp.ListOfficeGroupOccupancy)
	// key.PUT("/offices/:office_symbol/:group/occupancy", mp.UpdateOfficeGroupOccupancy)
	// key.DELETE("", mp.DeleteOfficeGroupOccupancy)

	// Server
	s := &http2.Server{
		MaxConcurrentStreams: 250,     // http2 default 250
		MaxReadFrameSize:     1048576, // http2 default 1048576
		IdleTimeout:          10 * time.Second,
	}
	if err := e.StartH2CServer(":80", s); err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
