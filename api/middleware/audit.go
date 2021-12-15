package middleware

import (
	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
)

var (
	applicationAdminRole = "application.admin"
)

type UserInfo struct {
	IsAdmin bool     `json:"is_admin"`
	Roles   []string `json:"roles"`
}

func AttachUserInfo(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		user := c.Get("user").(*jwt.Token)
		claims := user.Claims.(jwt.MapClaims)
		resourceAccess := claims["resource_access"].(map[string]interface{})
		// workforce Specific
		workforceResourceAccess := resourceAccess["workforce"].(map[string]interface{})
		workforceRoles := workforceResourceAccess["roles"].([]interface{})
		// Attach Role Info
		userInfo := UserInfo{
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

// func IsAdmin(next echo.HandlerFunc) echo.HandlerFunc {
// 	return func(c echo.Context) error {
// 		userInfo, ok := c.Get("userInfo").(UserInfo)
// 		if !ok {
// 			return c.JSON(http.StatusForbidden, map[string]string{})
// 		}
// 		if userInfo.IsAdmin {
// 			return next(c)
// 		}
// 		return c.JSON(http.StatusForbidden, map[string]string{})
// 	}
// }
