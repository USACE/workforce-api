package middleware

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"
	"github.com/golang-jwt/jwt"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

var (
	applicationAdminRole = "application.admin"
)

func AttachUserInfo(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		user := c.Get("user").(*jwt.Token)
		claims := user.Claims.(jwt.MapClaims)
		// Sub
		sub := claims["sub"].(string)
		uSub, err := uuid.Parse(sub)
		if err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{})
		}
		resourceAccess := claims["resource_access"].(map[string]interface{})
		// workforce Specific
		workforceResourceAccess := resourceAccess["workforce"].(map[string]interface{})
		workforceRoles := workforceResourceAccess["roles"].([]interface{})
		// Attach Role Info
		userInfo := models.UserInfo{
			Sub:     uSub,
			Roles:   make([]string, 0),
			IsAdmin: false,
		}
		for _, r := range workforceRoles {
			rStr, ok := r.(string)
			if !ok {
				return c.JSON(http.StatusInternalServerError, map[string]string{})
			}
			userInfo.Roles = append(userInfo.Roles, rStr)
			if rStr == applicationAdminRole {
				userInfo.IsAdmin = true
			}
		}
		c.Set("userInfo", userInfo)
		return next(c)
	}
}

func IsOfficeAdmin(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		userInfo, ok := c.Get("userInfo").(models.UserInfo)
		if !ok {
			return c.JSON(http.StatusForbidden, map[string]string{})
		}
		// Allow Role "application.admin"
		if userInfo.IsAdmin {
			return next(c)
		}
		// Allow Role "{:office_symbol}.admin"
		// (e.g. lrn.admin allowed to use /offices/lrn/... routes)
		officeSymbol := c.Param("office_symbol")
		for _, role := range userInfo.Roles {
			if strings.ToLower(role) == fmt.Sprintf("%s.admin", strings.ToLower(officeSymbol)) {
				return next(c)
			}
		}
		// Deny all
		return c.JSON(http.StatusForbidden, messages.DefaultMessageUnauthorized)
	}
}

func IsApplicationAdmin(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		userInfo, ok := c.Get("userInfo").(models.UserInfo)
		if !ok {
			return c.JSON(http.StatusForbidden, messages.DefaultMessageUnauthorized)
		}
		if userInfo.IsAdmin {
			return next(c)
		}
		return c.JSON(http.StatusForbidden, messages.DefaultMessageUnauthorized)
	}
}
