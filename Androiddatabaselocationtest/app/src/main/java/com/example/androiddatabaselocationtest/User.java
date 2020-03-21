package com.example.androiddatabaselocationtest;

import android.media.Image;

import com.bumptech.glide.Glide;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;


public class User {
    public String firstName;
    public String lastName;
    public String nick;
    public String uID;
    public Image profileImage;

    public User() {
        // Default constructor required for calls to DataSnapshot.getValue(CurrentLocation.class)
    }

    public User(String firstName, String lastName, String nick, String uID) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.nick = nick;
        this.uID = uID;
        fetchImage(uID);
    }

    public void fetchImage(String uID){
        StorageReference storageReference = FirebaseStorage.getInstance("gs://ioslocationdatabase.appspot.com").getReference().child(uID);
        MyAppGlideModule.with(this).load(storageReference).into();

    }
}
