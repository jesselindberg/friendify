package com.example.androiddatabaselocationtest;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.util.Log;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class NearbyPeopleActivity extends AppCompatActivity {

    private static final String TAG = "NearbyPeopleActivity";
    private ArrayList<User> users = new ArrayList<>();

    DatabaseReference userReference = FirebaseDatabase.getInstance().getReference().child("users");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nearby_people);



        userReference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {

                // Get users from Firebase
                // Get users and add them to ArrayList 'users'
                users.clear();
                for(DataSnapshot userDS : dataSnapshot.getChildren()) {
                    User user = userDS.child("data").getValue(User.class);
                    user.uID = userDS.getKey();

                    if(user != null && !user.username.isEmpty()) {
                        users.add(user);
                    }
                }

                // Pass 'users' ArrayList to RecyclerAdapter
                RecyclerView recyclerView = findViewById(R.id.cardsRecyclerView);
                recyclerView.setHasFixedSize(true);
                recyclerView.setLayoutManager(new LinearLayoutManager(NearbyPeopleActivity.this));
                RecyclerAdapter adapter = new RecyclerAdapter(users, NearbyPeopleActivity.this);
                recyclerView.setAdapter(adapter);

                Log.d(TAG, "Value is: " + users);
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Log.w(TAG, "Failed to read value.", error.toException());
            }
        });

        //onStart();
    }

    /*
    protected void onStart() {
        super.onStart();

        onResume();

    }

    protected void onResume() {
        super.onResume();



    }

    protected void onPause() {
        super.onPause();

        //users.clear();

    }
     */
}
