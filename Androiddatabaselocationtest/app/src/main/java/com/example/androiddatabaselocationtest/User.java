package com.example.androiddatabaselocationtest;


public class User {
    public String f_name;
    public String l_name;
    public String username;
    public String info;

    public User() {
        // Default constructor required for calls to DataSnapshot.getValue(CurrentLocation.class)
    }

    public User(String firstName, String lastName, String nick, String info) {
        this.f_name = firstName;
        this.l_name = lastName;
        this.username = nick;
        this.info = info;
    }


}
