package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-resty/resty/v2"
)

type GeocodingData struct {
	Lat float64 `json:"lat,string"`
	Lon float64 `json:"lon,string"`
}

type WeatherData struct {
	Current   struct {
		Temperature float64 `json:"temperature"`
		WindSpeed   float64 `json:"windspeed"`
	} `json:"current_weather"`
}

func getCoordinates(city, state string) (float64, float64, error) {
	client := resty.New()
	resp, err := client.R().
		SetQueryParams(map[string]string{
			"city":   fmt.Sprintf("%s", city),
			"state":  fmt.Sprintf("%s", state),
			"key":    "pk.f39ed97163f550902baa141600a39309",
			"format": "json",
		}).
		Get("https://us1.locationiq.com/v1/search")

	if err != nil {
		return 0, 0, err
	}

	var geocodingData []GeocodingData
	if err := json.Unmarshal(resp.Body(), &geocodingData); err != nil {
		return 0, 0, err
	}

	if len(geocodingData) == 0 {
		return 0, 0, fmt.Errorf("no results found for %s, %s", city, state)
	}

	return geocodingData[0].Lat, geocodingData[0].Lon, nil
}

func fetchWeather(lat, lon string) (*WeatherData, error) {
	client := resty.New()
	resp, err := client.R().
		SetResult(&WeatherData{}).
		Get(fmt.Sprintf("https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current_weather=true", lat, lon))

	if err != nil {
		return nil, err
	}

	return resp.Result().(*WeatherData), nil
}

func main() {
	router := gin.Default()

	router.GET("/", func(c *gin.Context) {
		city := c.Query("city")
		state := c.Query("state")

		if city == "" || state == "" {
			c.String(http.StatusBadRequest, "Please provide both city and state parameters")
			return
		}

		lat, lon, err := getCoordinates(city, state)
		if err != nil {
			log.Printf("Error getting coordinates: %v", err)
			c.String(http.StatusInternalServerError, "Error getting coordinates")
			return
		}

		weatherData, err := fetchWeather(fmt.Sprintf("%f", lat), fmt.Sprintf("%f", lon))
		if err != nil {
			log.Printf("Error fetching weather data: %v", err)
			c.String(http.StatusInternalServerError, "Error fetching weather data")
			return
		}

		c.HTML(http.StatusOK, "index.html", gin.H{
			"City":        city,
			"State":       state,
			"Temperature": weatherData.Current.Temperature,
			"WindSpeed":   weatherData.Current.WindSpeed,
		})
	})

	router.LoadHTMLGlob("templates/*")

	router.Run(":8080")
}
