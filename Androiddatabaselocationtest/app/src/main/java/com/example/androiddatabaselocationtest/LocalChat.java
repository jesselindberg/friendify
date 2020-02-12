package com.example.androiddatabaselocationtest;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.location.Location;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

public class LocalChat extends AppCompatActivity {

    private DatabaseReference mMessageReference;
    private RecyclerView mMessageRecycler;
    private MessageListAdapter mMessageAdapter;
    private Button sendButton;
    private TextView chatBox;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_local_chat);

        final List<Message> messageList = new ArrayList<>();
        final List<Message> sentMessageList = new ArrayList<>();
        mMessageRecycler = (RecyclerView) findViewById(R.id.chatRecyclerView);
        mMessageAdapter = new MessageListAdapter(this,messageList,sentMessageList);
        mMessageRecycler.setLayoutManager(new LinearLayoutManager(this));
        mMessageRecycler.setAdapter(mMessageAdapter);

        sendButton = findViewById(R.id.chatBtn);
        chatBox = findViewById(R.id.edittext_chatbox);
        mMessageReference = FirebaseDatabase.getInstance().getReference().child("messages");

        ChildEventListener messageListener = new ChildEventListener() {
            @Override
            public void onChildAdded(@NonNull final DataSnapshot dataSnapshot, @Nullable String s) {

                FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(LocalChat.this);
                fusedLocationClient.getLastLocation().addOnSuccessListener(LocalChat.this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            Message message = dataSnapshot.getValue(Message.class);
                            Location messageLocation = new Location("message location");
                            messageLocation.setLatitude(message.latitude);
                            messageLocation.setLongitude(message.longitude);

                            if (/*messageLocation.distanceTo(location <= 1000*/true) {
                                messageList.add(message);
                                mMessageAdapter.notifyDataSetChanged();
                            }

                        }
                    }
                });

            }

            @Override
            public void onChildChanged(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

            }

            @Override
            public void onChildRemoved(@NonNull DataSnapshot dataSnapshot) {

            }

            @Override
            public void onChildMoved(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        };
        mMessageReference.addChildEventListener(messageListener);

        final Button sendMessageBtn = (Button) findViewById(R.id.sendBtn);
        sendMessageBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(LocalChat.this);
                fusedLocationClient.getLastLocation().addOnSuccessListener(LocalChat.this, new OnSuccessListener<Location>() {
                    @Override
                    public void onSuccess(Location location) {
                        if (location != null) {
                            TextView sendMessageEditTextView = (TextView) findViewById(R.id.edittext_chatbox);
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

                            Message newMessage = new Message(latitude,longitude,time,sendMessageEditTextView.getText().toString());
                            sendMessageEditTextView.setText("");
                            sentMessageList.add(newMessage);
                            //messageList.add(newMessage);


                            FirebaseDatabase mDatabase = FirebaseDatabase.getInstance();
                            DatabaseReference mDatabaseReference;

                            mDatabaseReference = mDatabase.getReference().child("messages").push();
                            mDatabaseReference.setValue(newMessage);

                            mMessageAdapter.notifyDataSetChanged();
                        }
                    }
                });
            }
        });

    }
}
