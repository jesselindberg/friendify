package com.example.androiddatabaselocationtest;

public class CurrentLocation {
    public Double latitude;
    public Double longitude;
    public String time;

    public CurrentLocation() {
        // Default constructor required for calls to DataSnapshot.getValue(CurrentLocation.class)
    }

    public CurrentLocation(Double latitude, Double longitude, String time) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.time = time;
    }
}
