package com.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class WeatherController {

    @GetMapping("/")
    public Map<String, String> getWeather() {
        return Map.of(
            "location", "Your City",
            "forecast", "Sunny",
            "temperature", "25°C"
        );
    }
}
