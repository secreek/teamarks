package com.teamarks.android;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {

	private Button bt_setting;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        	Button bt_setting = (Button)findViewById(R.id.btnSetting);
        	bt_setting.setOnClickListener(new OnClickListener()
        	{

				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Intent intent =new Intent();
					intent.setClass(MainActivity.this, SettingActivity.class);
					MainActivity.this.startActivity(intent);
					
					
				}       		
        	
    });
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }
    
    
}
