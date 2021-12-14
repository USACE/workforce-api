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
	"github.com/labstack/echo/v4"
)

func main() {

	// parse configuration from environment variables
	// Environment Variable Config
	cfg, err := app.GetConfig()
	if err != nil {
		log.Fatal(err.Error())
	}
	// create store (database pool) from configuration
	st, err := app.NewStore(*cfg)
	if err != nil {
		log.Fatal(err.Error())
	}

	e := echo.New()                         // All Routes
	e.Use(middleware.CORS, middleware.GZIP) // All Routes Middleware

	// Public Routes
	public := e.Group("")

	// Private Routes Supporting CAC (JWT) or Key Auth
	private := e.Group("")

	// JWT (CAC) Middleware
	if cfg.AuthMocked {
		private.Use(middleware.JWTMock(cfg.AuthMocked, true))
	} else {
		private.Use(middleware.JWT(cfg.AuthMocked, true))
	}
	// Key Auth Middleware
	private.Use(
		middleware.KeyAuth(cfg.AuthMocked, cfg.ApplicationKey),
		middleware.AttachUserInfo,
	)

	// Private Routes w/ Access Control
	// private := e.Group("")
	// if config.AuthMocked {
	// 	// @todo. re-add JWTMock
	// 	// private.Use(middleware.JWTMock)
	// 	log.Println("Auth is Disabled...")
	// } else {
	// 	private.Use(middleware.JWT, middleware.AttachUserInfo)
	// }

	// App Routes (Intended to be used by application only)
	key := e.Group("")
	key.Use(middleware.KeyAuth(cfg.AuthMocked, cfg.ApplicationKey))

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

	key.POST("/offices/:office_symbol/:group_slug/groups", mp.CreateOfficeGroup)
	// key.DELETE("/offices/:office_symbol/:group_slug/groups/:group_id", mp.DeleteOfficeGroup)

	// Office Positions/Employees
	public.GET("/offices/:office_symbol/positions", mp.ListPositions)
	public.GET("/offices/:office_symbol/:group_slug/positions", mp.ListPositionsByGroup)

	key.POST("/offices/:office_symbol/:group_slug/positions", mp.CreateOfficePosition)
	key.PUT("/offices/:office_symbol/:group_slug/:position_id", mp.UpdatePosition)

	// Occupancy
	key.POST("/occupancy", mp.CreateOccupancy)
	public.GET("/occupancy/:occupancy_id", mp.GetOccupancyByID)
	public.GET("/offices/:office_symbol/occupancy", mp.ListOccupancy)
	public.GET("offices/:office_symbol/:group_slug/occupancy", mp.ListOccupancyByGroup)
	// key.PUT("", mp.UpdateOccupancy)
	// key.DELETE("", mp.DeleteOccupancy)

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
