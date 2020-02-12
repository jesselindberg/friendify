package com.example.androiddatabaselocationtest;

public class User {
    public String name;
    public String nick;
    public String uID;

    public User() {
        // Default constructor required for calls to DataSnapshot.getValue(CurrentLocation.class)
    }

    public User(String name, String nick, String uID) {
        this.name = name;
        this.nick = nick;
        this.uID = uID;
    }
}
