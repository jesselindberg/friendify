package com.example.androiddatabaselocationtest;

import androidx.annotation.NonNull;
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

import com.google.firebase.auth.FirebaseAuth;

import java.util.ArrayList;

public class ActiveChatsActivity extends AppCompatActivity {

    private static final String TAG = "NearbyPeopleActivity";
    private ArrayList<User> users = new ArrayList<>();

    DatabaseReference userReference;
    DatabaseReference userChatsReference;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nearby_people);


        final String uID = FirebaseAuth.getInstance().getCurrentUser().getUid();
        userReference = FirebaseDatabase.getInstance().getReference().child("users");

        userReference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                users.clear();
                for(DataSnapshot otherUidDS : dataSnapshot.child(uID + "/chats").getChildren()) {
                    String otherUID = otherUidDS.getKey();
                    User user = dataSnapshot.child(otherUID + "/data").getValue(User.class);
                    user.uID = otherUID;
                    if(user != null && !user.username.isEmpty()) {
                        users.add(user);
                    }
                }

                // Pass 'users' ArrayList to RecyclerAdapter
                RecyclerView recyclerView = findViewById(R.id.cardsRecyclerView);
                recyclerView.setHasFixedSize(true);
                recyclerView.setLayoutManager(new LinearLayoutManager(ActiveChatsActivity.this));
                RecyclerAdapter adapter = new RecyclerAdapter(users, ActiveChatsActivity.this);
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
