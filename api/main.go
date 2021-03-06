package main

import (
	"log"
	"net/http"
	"strings"
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

	// Private Routes w/ Access Control
	if cfg.AuthMocked {
		private.Use(middleware.JWTMock, middleware.AttachUserInfo)
	} else {
		if strings.ToUpper(cfg.AuthEnvironment) == "DEVELOP" {
			private.Use(middleware.JWTDevelop, middleware.AttachUserInfo)
		} else {
			private.Use(middleware.JWTStable, middleware.AttachUserInfo)
		}
	}

	// Health Check
	public.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{"status": "healthy"})
	})

	/////////////////////////////////////////////////////////////////////////////
	// Manpower
	/////////////////////////////////////////////////////////////////////////////
	// Manpower Store
	mp := workforce.Store{Connection: st.Connection}

	// Role Requests (All Authenticated Users)
	private.GET("/my_role_requests", mp.ListMyRoleRequests)
	private.POST("/role_requests/:office_symbol", mp.CreateRoleRequest)
	// Role Requests (Application Admin Use Only)
	private.GET("/role_requests", mp.ListRoleRequests, middleware.IsApplicationAdmin)
	private.POST("/role_requests/:role_request_id/approve", mp.UpdateRoleRequestStatus("APPROVED"), middleware.IsApplicationAdmin)
	private.POST("/role_requests/:role_request_id/deny", mp.UpdateRoleRequestStatus("DENIED"), middleware.IsApplicationAdmin)

	// Metrics
	public.GET("/metrics/series", mp.SeriesMetrics)
	public.GET("/metrics/age", mp.AgeMetrics)
	public.GET("/metrics/demographics", mp.DemographicsMetrics)

	// Codes --> Used in Python script
	public.GET("/occupation_codes", mp.ListOccupationCodes)
	public.GET("/pay_plans", mp.ListPayPlanCodes)

	// Offices
	public.GET("/offices", mp.ListOffices)
	public.GET("/offices/:office_symbol", mp.GetOffice)

	// Positions
	public.GET("/position/:position_id", mp.GetPositionByID)

	// Groups
	public.GET("/groups", mp.ListGroups) // Used in Python script
	public.GET("/offices/:office_symbol/groups", mp.ListOfficeGroups)

	private.POST("/offices/:office_symbol/groups", mp.CreateOfficeGroup, middleware.IsOfficeAdmin)
	private.PUT("/offices/:office_symbol/groups/:group_slug", mp.UpdateOfficeGroup, middleware.IsOfficeAdmin)
	private.DELETE("/offices/:office_symbol/groups/:group_slug", mp.DeleteOfficeGroup, middleware.IsOfficeAdmin)
	private.POST("/offices/:office_symbol/groups/:group_slug/verify", mp.VerifyOfficeGroup, middleware.IsOfficeAdmin)

	// Office Positions/Employees
	public.GET("/offices/:office_symbol/positions", mp.ListPositions)
	public.GET("/offices/:office_symbol/:group_slug/positions", mp.ListPositionsByGroup)

	private.POST("/offices/:office_symbol/positions", mp.CreateOfficePosition, middleware.IsOfficeAdmin)
	private.PUT("/offices/:office_symbol/positions/:position_id", mp.UpdateOfficePosition, middleware.IsOfficeAdmin)
	private.DELETE("/offices/:office_symbol/positions/:position_id", mp.DeleteOfficePosition, middleware.IsOfficeAdmin)

	// Occupancy
	private.POST("/offices/:office_symbol/occupancy", mp.CreateOccupancy, middleware.IsOfficeAdmin)
	private.PUT("/offices/:office_symbol/occupancy/:occupancy_id", mp.UpdateOccupancy, middleware.IsOfficeAdmin)
	public.GET("/occupancy/:occupancy_id", mp.GetOccupancyByID)
	public.GET("/offices/:office_symbol/occupancy", mp.ListOccupancyByOffice)
	public.GET("/offices/:office_symbol/:group_slug/occupancy", mp.ListOccupancyByGroup)

	// Credentials
	public.GET("/credentials", mp.GetCredentials)

	// Expertise
	public.GET("/expertise", mp.ListExpertise)

	//Normalized Export Report
	public.GET("/report/csv", mp.ExportNormalizedPositions)
	public.GET("/report/json", mp.ListNormalizedPositions)

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
