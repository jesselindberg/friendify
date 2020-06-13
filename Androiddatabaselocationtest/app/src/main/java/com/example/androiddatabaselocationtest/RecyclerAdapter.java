package com.example.androiddatabaselocationtest;

import android.content.Context;
import android.content.Intent;
import android.media.Image;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.ArrayList;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class RecyclerAdapter extends RecyclerView.Adapter<RecyclerAdapter.ViewHolder> {

    private static final String TAG = "RecyclerAdapter";
    private ArrayList<User> users;
    private Context mContext;

    public RecyclerAdapter(ArrayList<User> users, Context mContext) {
        this.users = users;
        this.mContext = mContext;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.card, parent, false);
        ViewHolder holder = new ViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        Log.d(TAG, "onBindViewHolder: New item added");
        holder.username.setText(users.get(position).username);
        holder.chatButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mContext, OneOnOneChatActivity.class);
                intent.putExtra("otherUID", users.get(position).uID);
                mContext.startActivity(intent);
            }
        });

        final DatabaseReference userReactions = FirebaseDatabase.getInstance().getReference().child("users/" + users.get(position).uID + "/reactions");
        FirebaseAuth mAuth;
        mAuth = FirebaseAuth.getInstance();
        final FirebaseUser user = mAuth.getCurrentUser();
        final String uID = user.getUid();

        holder.likeReactionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                likeReactionClick(uID, userReactions);
            }
        });
    }

    @Override
    public int getItemCount() {
        return users.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView username;
        CardView userInfoCard;
        Button chatButton;
        ImageButton likeReactionButton;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            username = itemView.findViewById(R.id.cardUsername);
            userInfoCard = itemView.findViewById(R.id.userInfoCard);
            this.chatButton = (Button) itemView.findViewById(R.id.oneOnOneChatBtn);
            this.likeReactionButton = (ImageButton) itemView.findViewById(R.id.likeReactionBtn);
        }
    }


    private void likeReactionClick(final String uID, final DatabaseReference userReactions) {
        userReactions.child("/like").addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                System.out.println(dataSnapshot);
                if (dataSnapshot.hasChild(uID)) {
                    userReactions.child("/like/" + uID).removeValue();
                    System.out.println("kulli");
                } else {
                    userReactions.child("/like/" + uID).setValue("");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });

    }

}
