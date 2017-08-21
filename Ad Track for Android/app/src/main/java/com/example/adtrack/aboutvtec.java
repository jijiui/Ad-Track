package com.example.adtrack;

/*
 * This activity is to show a page introducing VTEC
 */

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;



public class aboutvtec extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //set UI
        setContentView(R.layout.aboutvtec);
        TextView tv_aboutvtec = (TextView) findViewById(R.id.tv_aboutvtec);

        tv_aboutvtec.setTextColor(android.graphics.Color.WHITE);
    }


    //when BACK button is clicked, the UI will go to MainActivity
    public void goBack(View view) {
        startActivity(new Intent("MainActivity"));
    }

}
