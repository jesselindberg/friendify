package com.example.androiddatabaselocationtest;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.facebook.login.LoginManager;
import com.google.firebase.auth.FirebaseAuth;

import java.util.Locale;

public class LaunchActivity extends AppCompatActivity {

    FirebaseAuth mAuth;
    FirebaseAuth.AuthStateListener mAuthListener;

    @Override
    protected void onStart() {
        super.onStart();
        mAuth.addAuthStateListener(mAuthListener);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch);

        mAuth = FirebaseAuth.getInstance();

        mAuthListener = new FirebaseAuth.AuthStateListener() {
            @Override
            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
                if(firebaseAuth.getCurrentUser() == null) {
                    startActivity(new Intent(LaunchActivity.this, SignInActivity.class));
                }
            }
        };

        final TextView launchActivityNameTextView = findViewById(R.id.launchActivityNameTxt);

        final Button activeChatsButton = (Button) findViewById(R.id.activeChatsBtn);
        activeChatsButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LaunchActivity.this, ActiveChatsActivity.class);
                startActivity(intent);
            }
        });

        final Button chatWithJalliButton = (Button) findViewById(R.id.chatWithJalliBtn);
        chatWithJalliButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LaunchActivity.this, OneOnOneChatActivity.class);
                intent.putExtra("otherUID", "GWANMHWhZMWFO2qPOU4eEZiOnt43");
                startActivity(intent);
            }
        });

        final Button chatButton = (Button) findViewById(R.id.chatBtn);
        chatButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LaunchActivity.this, LocalChat.class);
                startActivity(intent);
            }
        });

        final Button signOutButton = (Button) findViewById(R.id.signOutBtn);
        signOutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                signOut();
            }
        });

        final Button profileButton = (Button) findViewById(R.id.profileBtn);
        profileButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LaunchActivity.this, ProfileActivity.class);
                startActivity(intent);
            }
        });

        final Button nearbyPeopleButton = (Button) findViewById(R.id.nearbyPeopleBtn);
        nearbyPeopleButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LaunchActivity.this, NearbyPeopleActivity.class);
                startActivity(intent);
            }
        });

    }

    public void signOut() {
        mAuth.signOut();
        LoginManager.getInstance().logOut();
    }

}
