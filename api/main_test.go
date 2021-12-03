package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/USACE/workforce-api/api/app"
	"github.com/USACE/workforce-api/api/workforce"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/kelseyhightower/envconfig"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

var (
	config app.Config
	st     *app.PGStore
	err    error
	mp     workforce.Store
)

func init() {
	config = app.Config{
		ApplicationKey:        "appkey",
		AuthMocked:            true,
		DBUser:                "workforce_user",
		DBPass:                "workforce_pass",
		DBName:                "postgres",
		DBHost:                "localhost",
		DBSSLMode:             "disable",
		DBPoolMaxConns:        10,
		DBPoolMaxConnIdleTime: 10,
		DBPoolMinConns:        5,
	}

	// parse configuration from environment variables
	if err := envconfig.Process("workforce", &config); err != nil {
		log.Fatal(err.Error())
	}
	// create store (database pool) from configuration
	st, err = app.NewStore(config)
	if err != nil {
		log.Fatal(err.Error())
	}
	mp = workforce.Store{Connection: st.Connection}
}

// setupGet
func setupGet() (*http.Request, *httptest.ResponseRecorder, echo.Context) {
	e := echo.New() // All Routes
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	return req, rec, c
}

// TestListOffices
func TestListOffices(t *testing.T) {
	_, rec, c := setupGet()
	c.SetPath("/offices")
	if assert.NoError(t, mp.ListOffices(c)) {
		b := rec.Body.String()
		var out bytes.Buffer
		json.Indent(&out, []byte(b), "", "    ")
		fmt.Printf("%s", out.Bytes())
	}
}

// TestListOfficePositions
func TestListOfficePositions(t *testing.T) {
	_, rec, c := setupGet()
	c.SetPath("/offices/:office_symbol/positions")
	c.SetParamNames("office_symbol")
	c.SetParamValues("LRH")
	if assert.NoError(t, mp.ListOfficePositions(c)) {
		b := rec.Body.String()
		var out bytes.Buffer
		json.Indent(&out, []byte(b), "", "    ")
		fmt.Printf("%s", out.Bytes())
	}
}

// TestListOfficeGroupPositions
func TestListOfficeGroupPositions(t *testing.T) {
	_, rec, c := setupGet()
	c.SetPath("/offices/:office_symbol/:group/positions")
	c.SetParamNames("office_symbol", "group")
	c.SetParamValues("LRH", "water-management")
	if assert.NoError(t, mp.ListOfficeGroupPositions(c)) {
		b := rec.Body.String()
		var out bytes.Buffer
		json.Indent(&out, []byte(b), "", "    ")
		fmt.Printf("%s", out.Bytes())
	}
}

// TestCreateOfficePosition
func TestCreateOfficePosition(t *testing.T) {
	var path, payload string
	path = "/offices/:office_symbol/:group/positions"
	payload = `{
		"position_title": "Super Trooper Engineer",
		"code": "GS",
		"position_grade": "15",
		"is_supervisor": false,
		"occupation_code": "0810"
		}`
	// Setup the request parameters and body
	e := echo.New()

	req := httptest.NewRequest(http.MethodPost, "/", strings.NewReader(payload))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAccept, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	c.SetPath(path)
	c.SetParamNames("office_symbol", "group")
	c.SetParamValues("LRH", "water-management")

	body := c.Request().Body
	b, _ := ioutil.ReadAll(body)
	p := new(models.Position)
	json.Unmarshal(b, p)
	fmt.Println(p)
	mp.CreateOfficeGroupPosition(c)

	// if assert.NoError(t, mp.CreateOfficePosition(c)) {
	// 	b := rec.Body.String()
	// 	var out bytes.Buffer
	// 	json.Indent(&out, []byte(b), "", "    ")
	// 	fmt.Printf("%s", out.Bytes())
	// }

}

// TestGetPosition
// func TestGetPosition(t testing.T) {
// 	_, rec, c := setupGet()
// 	c.SetPath("/position/:position_id")
// 	c.SetParamNames("position_id")
// 	c.SetParamValues("")
// 	if assert.NoError(t, mp.GetPosition(c)) {
// 		b := rec.Body.String()
// 		var out bytes.Buffer
// 		json.Indent(&out, []byte(b), "", "    ")
// 		fmt.Printf("%s", out.Bytes())
// 	}
// }
