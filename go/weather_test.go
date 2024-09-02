package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetCoordinates(t *testing.T) {
	lat, lon, err := getCoordinates("Boca Raton", "FL")
	assert.NoError(t, err)
	assert.Equal(t, 26.3586885, lat)
	assert.Equal(t, -80.0830984, lon)
}

func TestFetchWeather(t *testing.T) {
	weatherData, err := fetchWeather("26.3586885", "-80.0830984")
	assert.NoError(t, err)
	assert.NotNil(t, weatherData)
	assert.NotNil(t, weatherData.Current.Temperature)
	assert.NotNil(t, weatherData.Current.WindSpeed)
}
