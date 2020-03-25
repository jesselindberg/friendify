package com.example.androiddatabaselocationtest;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.ArrayList; //Use this if you want nested database structures
import java.util.HashMap;
import java.util.TimeZone;

public class MainActivity extends AppCompatActivity {

    private DatabaseReference mMessageReference;
    private TextView messagesTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        messagesTextView = findViewById(R.id.messagesTextView);
        mMessageReference = FirebaseDatabase.getInstance().getReference().child("messages");

        FirebaseAuth mAuth = FirebaseAuth.getInstance();
        FirebaseUser curUser = mAuth.getCurrentUser();
        final String uID = curUser.getUid();


        ValueEventListener messageListener = new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull final DataSnapshot dataSnapshot) {

                FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(MainActivity.this);
                fusedLocationClient.getLastLocation().addOnSuccessListener(MainActivity.this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            String text = "";
                            for (DataSnapshot curMessage : dataSnapshot.getChildren()) {
                                Message message = curMessage.getValue(Message.class);
                                Location messageLocation = new Location("message location");
                                messageLocation.setLatitude(message.latitude);
                                messageLocation.setLongitude(message.longitude);

                                if (messageLocation.distanceTo(location) <= 1000){
                                    text += message.message + "\n";
                                }
                            }
                            messagesTextView.setText(text);
                        }
                    }
                });
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        };
        mMessageReference.addValueEventListener(messageListener);


        final Button addLocationToDataBaseBtn = (Button) findViewById(R.id.addLocationToDataBaseBtn);
        addLocationToDataBaseBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(MainActivity.this);
                fusedLocationClient.getLastLocation().addOnSuccessListener(MainActivity.this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            Double latitude = location.getLatitude();
                            Double longitude = location.getLongitude();

                            // Get current time in ISO 8601 format
                            // Input
                            Calendar calendar = Calendar.getInstance();
                            calendar.set(Calendar.MILLISECOND, 0);
                            Date date = calendar.getTime();

                            // Conversion
                            SimpleDateFormat sdf;
                            sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                            sdf.setTimeZone(TimeZone.getTimeZone("CET"));
                            String time = sdf.format(date);

                            CurrentLocation curLocation = new CurrentLocation(latitude,longitude,time);
                            ArrayList<CurrentLocation> newEntry = new ArrayList<CurrentLocation>();
                            newEntry.add(curLocation);

                            FirebaseDatabase mDatabase = FirebaseDatabase.getInstance();
                            DatabaseReference mDatabaseReference;

                            mDatabaseReference = mDatabase.getReference().child("device_data/" + Build.MODEL);
                            mDatabaseReference.setValue(newEntry);
                        }
                    }
                });



                /*
                EditText firstNumEditText = (EditText) findViewById(R.id.firstNumEditText);
                EditText secondNumEditText = (EditText) findViewById(R.id.secondNumEditText);
                TextView resultTextView = (TextView) findViewById(R.id.resultTextView);

                int num1 = Integer.parseInt(firstNumEditText.getText().toString());
                int num2 = Integer.parseInt(secondNumEditText.getText().toString());
                int result = num1 + num2;
                resultTextView.setText(result + "");
                */
            }
        });


        final Button showEntriesFromDataBaseBtn = (Button) findViewById(R.id.showEntriesFromDataBaseBtn);
        showEntriesFromDataBaseBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FirebaseDatabase.getInstance().getReference().child("device_data")
                        .addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                        TextView deviceDataTextView = (TextView) findViewById(R.id.deviceDataTextView);

                        HashMap<String, CurrentLocation> usersAndLocations = new HashMap<>();
                        String text = "";
                        for (DataSnapshot device : dataSnapshot.getChildren()) {
                            for (DataSnapshot snapshot : device.getChildren()) {
                                CurrentLocation location = snapshot.getValue(CurrentLocation.class);
                                usersAndLocations.put(device.getKey(), location);
                                text += "Name: " + device.getKey() + ", latitude: " + location.latitude + ", longitude: " + location.longitude + ", time: " + location.time + "\n";
                            }
                        }

                        System.out.println(usersAndLocations);
                        deviceDataTextView.setText(text);

                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError databaseError) {

                    }
                });
            }
        });


        final Button sendMessageBtn = (Button) findViewById(R.id.sendMessageBtn);
        sendMessageBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(MainActivity.this);
                fusedLocationClient.getLastLocation().addOnSuccessListener(MainActivity.this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            TextView sendMessageEditTextView = (TextView) findViewById(R.id.sendMessageEditTextView);
                            Double latitude = location.getLatitude();
                            Double longitude = location.getLongitude();

                            // Get current time in ISO 8601 format
                            // Input
                            Calendar calendar = Calendar.getInstance();
                            calendar.set(Calendar.MILLISECOND, 0);
                            Date date = calendar.getTime();

                            // Conversion
                            SimpleDateFormat sdf;
                            sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                            sdf.setTimeZone(TimeZone.getTimeZone("CET"));
                            String time = sdf.format(date);

                            Message newMessage = new Message(latitude,longitude,time,sendMessageEditTextView.getText().toString(), uID);

                            FirebaseDatabase mDatabase = FirebaseDatabase.getInstance();
                            DatabaseReference mDatabaseReference;

                            mDatabaseReference = mDatabase.getReference().child("messages").push();
                            mDatabaseReference.setValue(newMessage);
                        }
                    }
                });
            }
        });
    }
}
