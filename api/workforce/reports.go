package workforce

import (
	"encoding/csv"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"reflect"
	"strconv"

	"github.com/USACE/workforce-api/api/messages"
	"github.com/USACE/workforce-api/api/workforce/models"

	"github.com/labstack/echo/v4"
)

func GetFields(row models.NormalizedPosition) (res []string) {

	v := reflect.ValueOf(row)
	for j := 0; j < v.NumField(); j++ {

		fmt.Println("var1 = ", reflect.TypeOf(row))
		res = append(res, v.Field(j).String())
	}
	return
}

func GetFieldsNames(row models.NormalizedPosition) (res []string) {

	fields := reflect.TypeOf(row)
	for i := 0; i < fields.NumField(); i++ {
		field := fields.Field(i)
		res = append(res, field.Tag.Get("db"))
		//fmt.Println(field.Tag.Get("db"))
		// value := values.Field(i)
		// fmt.Print("Type:", field.Type, ",", field.Name, "=", value, "\n")
	}
	return

}

// ListNormalizedPositions lists raw normalized positions for report consumption
func (s Store) ExportNormalizedPositions(c echo.Context) error {
	pp, err := models.ListNormalizedPositions(s.Connection)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}

	// Getting the path name for the executable
	// that started the current process.
	pathExecutable, err := os.Executable()
	if err != nil {
		panic(err)
	}
	// Getting the directory path/name
	dirPathExecutable := filepath.Dir(pathExecutable)

	fmt.Println("Directory of the currently running file...")
	fmt.Println(dirPathExecutable)

	tmpFile, err := ioutil.TempFile(dirPathExecutable, "download-")
	if err != nil {
		log.Fatal("Cannot create temporary file", err)
	}

	// Remember to clean up the file afterwards
	defer os.Remove(tmpFile.Name())

	fmt.Println("Created File: " + tmpFile.Name())

	writer := csv.NewWriter(tmpFile)
	defer writer.Flush()

	// header := []string{"vegetable", "fruit", "rank"}
	// if err := writer.Write(header); err != nil {
	// 	return err
	// }

	var csvRow []string
	headerNames := GetFieldsNames(pp[0])

	//fmt.Println(strings.Join(headerNames, ","))

	// Write the header row
	if err := writer.Write(headerNames); err != nil {
		return err
	}

	// @todo Future cleanup
	// Use GetFields() to return row values with dynamic types

	//csvRow = append(csvRow, strings.Join(headerNames, ","))

	// fields := reflect.TypeOf(pp[0])
	// values := reflect.ValueOf(pp[0])
	// //csvRow = append(csvRow, header.Field(0))

	// num := fields.NumField()

	// for i := 0; i < num; i++ {

	// 	field := fields.Field(i)
	// 	fmt.Println(field.Tag.Get("db"))
	// 	value := values.Field(i)
	// 	fmt.Print("Type:", field.Type, ",", field.Name, "=", value, "\n")

	// 	// switch value.Kind() {
	// 	// case reflect.String:
	// 	// 	v := value.String()
	// 	// 	fmt.Print(v, "\n")
	// 	// case reflect.Int:
	// 	// 	v := strconv.FormatInt(value.Int(), 10)
	// 	// 	fmt.Print(v, "\n")
	// 	// case reflect.Int32:
	// 	// 	v := strconv.FormatInt(value.Int(), 10)
	// 	// 	fmt.Print(v, "\n")
	// 	// case reflect.Int64:
	// 	// 	v := strconv.FormatInt(value.Int(), 10)
	// 	// 	fmt.Print(v, "\n")
	// 	// default:
	// 	// 	assert.Fail(t, "Not support type of struct")
	// 	// }
	// }

	// Loop over database results
	for _, row := range pp {

		csvRow := append(csvRow,
			row.ParentOfficeSymbol, row.ParentOfficeName, row.OfficeSymbol, row.OfficeName,
			row.GroupName, row.OccupationCode, row.OccupationName, row.Title, row.PayPlanCode,
			strconv.Itoa(row.TargetGrade), row.PayPlanGrade, strconv.Itoa(row.IsVacant),
			strconv.Itoa(row.IsSupervisor), strconv.Itoa(row.IsAllocated),
			row.LastUpdated.Format("2006-01-02"), row.AgeRange, row.ServiceRange,
			strconv.Itoa(row.ProfRegCnt), strconv.Itoa(row.AdvDegCnt), strconv.Itoa(row.CertCnt),
			strconv.Itoa(row.ExpHydrology), strconv.Itoa(row.ExpHydraulics),
			strconv.Itoa(row.ExpCoastal), strconv.Itoa(row.ExpWM),
			strconv.Itoa(row.ExpWQ))

		// Write db records to CSV
		if err := writer.Write(csvRow); err != nil {
			return err
		}
	}

	writer.Flush()

	// Close the file
	if err := tmpFile.Close(); err != nil {
		log.Fatal(err)
	}

	//return c.File(tmpFile.Name())
	return c.Attachment(tmpFile.Name(), "workforce-export.csv")

	// var CsvData []string
	// for _, v := range pp {
	// 	CsvData = append(CsvData, GetFields(v)...)
	// }
	// fmt.Printf("%q\n", CsvData)
	// return c.String(http.StatusOK, strings.Join(CsvData, ","))
}

func (s Store) ListNormalizedPositions(c echo.Context) error {
	pp, err := models.ListNormalizedPositions(s.Connection)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, messages.NewMessage(err.Error()))
	}
	return c.JSON(http.StatusOK, pp)
}
