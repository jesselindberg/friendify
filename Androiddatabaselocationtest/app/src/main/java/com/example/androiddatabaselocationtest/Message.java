package com.example.androiddatabaselocationtest;

public class Message {
    public Double latitude;
    public Double longitude;
    public String time;
    public String message;
    public String senderID;

    public Message() {
        // Default constructor required for calls to DataSnapshot.getValue(CurrentLocation.class)
    }

    public Message(Double latitude, Double longitude, String time, String message, String senderID) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.time = time;
        this.message = message;
        this.senderID = senderID;
    }

    public Boolean isSame(Message otherMessage) {
        return (this.message == otherMessage.message) && (this.time == otherMessage.time);// && (this.longitude == otherMessage.longitude)
                //&& (this.message == otherMessage.message) && (this.time == otherMessage.time));
    }
}
