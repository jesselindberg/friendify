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

    public String getF_name() {
        return f_name;
    }

    public void setF_name(String f_name) {
        this.f_name = f_name;
    }

    public String getL_name() {
        return l_name;
    }

    public void setL_name(String l_name) {
        this.l_name = l_name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    @Override
    public String toString() {
        return "User{" +
                "f_name='" + f_name + '\'' +
                ", l_name='" + l_name + '\'' +
                ", username='" + username + '\'' +
                ", info='" + info + '\'' +
                '}';
    }
}
