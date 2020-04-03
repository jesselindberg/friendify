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
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

public class OneOnOneChatActivity extends AppCompatActivity {

    private DatabaseReference mMessageReference;
    private DatabaseReference mUserReference;
    private RecyclerView mMessageRecycler;
    private MessageListAdapter mMessageAdapter;
    private Button sendButton;
    private TextView chatBox;
    private TextView sendMessageEditTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_local_chat);

        final List<Message> messageList = new ArrayList<>();
        mMessageRecycler = (RecyclerView) findViewById(R.id.chatRecyclerView);
        mMessageAdapter = new MessageListAdapter(this,messageList);
        final LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setSmoothScrollbarEnabled(true);
        mMessageRecycler.setLayoutManager(layoutManager);
        mMessageRecycler.setAdapter(mMessageAdapter);

        sendButton = findViewById(R.id.chatBtn);
        chatBox = findViewById(R.id.edittext_chatbox);

        FirebaseAuth mAuth = FirebaseAuth.getInstance();
        FirebaseUser curUser = mAuth.getCurrentUser();
        final String uID = curUser.getUid();
        String otherUID = "GWANMHWhZMWFO2qPOU4eEZiOnt43";
        String chatID;

        if (uID.compareTo(otherUID) < 0) {
            chatID = uID + otherUID;
        } else {
            chatID = otherUID + uID;
        }




        mMessageReference = FirebaseDatabase.getInstance().getReference().child("chats/" + chatID);
        mUserReference = FirebaseDatabase.getInstance().getReference().child("users/" + otherUID + "/chats/" + uID + "/last");
        sendMessageEditTextView =  (TextView) findViewById(R.id.edittext_chatbox);


        ChildEventListener messageListener = new ChildEventListener() {
            @Override
            public void onChildAdded(@NonNull final DataSnapshot dataSnapshot, @Nullable String s) {


            Message message = dataSnapshot.getValue(Message.class);

            messageList.add(message);
            mMessageAdapter.notifyDataSetChanged();
            layoutManager.scrollToPosition(mMessageAdapter.getItemCount()-1);


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

                final String text = sendMessageEditTextView.getText().toString();
                if (text.trim().length() > 0) {

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

                    Message newMessage = new Message(time, text, uID);
                    mMessageReference.push().setValue(newMessage);
                    sendMessageEditTextView.setText("");
                    mUserReference.setValue(newMessage);

                    mMessageAdapter.notifyDataSetChanged();
                    layoutManager.scrollToPosition(mMessageAdapter.getItemCount() - 1);

                }
            }
        });

    }
}
