package com.example.androiddatabaselocationtest;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.util.Log;
import android.widget.EditText;
import android.widget.TextView;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class NearbyPeopleActivity extends AppCompatActivity {

    private static final String TAG = "NearbyPeopleActivity";
    private ArrayList<String>usernames = new ArrayList<>();

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference users = database.getReference("users");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nearby_people);

        users.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                // Get users from firebase database
                // Get usernames and add them to ArrayList 'usernames'
                for(DataSnapshot child : dataSnapshot.getChildren()) {
                    Map<String, Object> users = (Map<String, Object>)child.getValue();

                    String username = (String) users.get("username");

                    if(!username.equals("")) {
                        usernames.add(username);
                    }
                }

                // Pass 'usernames' ArrayList to RecyclerAdapter
                RecyclerView recyclerView = findViewById(R.id.cardsRecyclerView);
                recyclerView.setHasFixedSize(true);
                recyclerView.setLayoutManager(new LinearLayoutManager(NearbyPeopleActivity.this));
                RecyclerAdapter adapter = new RecyclerAdapter(usernames, NearbyPeopleActivity.this);
                recyclerView.setAdapter(adapter);

                Log.d(TAG, "Value is: " + users);
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Log.w(TAG, "Failed to read value.", error.toException());
            }
        });
    }
}
