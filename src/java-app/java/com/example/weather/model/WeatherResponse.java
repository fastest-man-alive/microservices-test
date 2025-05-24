package com.example.weather.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class WeatherResponse {
    private Main main;
    private String name;

    public Main getMain() { return main; }
    public void setMain(Main main) { this.main = main; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public static class Main {
        private double temp;
        private double feels_like;

        public double getTemp() { return temp; }
        public void setTemp(double temp) { this.temp = temp; }

        public double getFeels_like() { return feels_like; }
        public void setFeels_like(double feels_like) { this.feels_like = feels_like; }
    }
}
