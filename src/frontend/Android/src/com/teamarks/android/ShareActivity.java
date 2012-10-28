package com.teamarks.android;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;

import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class ShareActivity extends Activity {
	
	private String title;
	private String url;
	private String text;

	private EditText etShareTitle;
	private EditText etShareLink;
	private EditText etShareText;
	private TextView tvShareTitle;
	private TextView tvShareLink;
	private TextView tvShareText;
	private Button	btShare;
	
	public SharedPreferences setting;
	public String username;
	public String apikey;
	
	ArrayList<NameValuePair> postParameters;
	
	public static String endpoint ="http://api.teamarks.com/v1/share?";
	
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_share);
        createWidget();
        
        Intent shareIntent = getIntent();
        url =ShareUtils.getBody(shareIntent);
        title = ShareUtils.getSubject(shareIntent);


        etShareTitle.setText(title);
        etShareLink.setText(url);
    }

    private String URLEncoder(String body, String string) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_share, menu);
        return true;
    }
    

    public void createWidget(){
    	
    		
    		etShareTitle = (EditText)findViewById(R.id.et_share_title);
    		etShareLink = (EditText)findViewById(R.id.et_share_link);    	
    		etShareText = (EditText)findViewById(R.id.et_share_text);
    		
    		tvShareTitle = (TextView)findViewById(R.id.tv_share_title);
    		tvShareTitle = (TextView)findViewById(R.id.tv_share_link);
    		tvShareTitle = (TextView)findViewById(R.id.tv_share_text);
    		
    		btShare = (Button)findViewById(R.id.bt_share);
    		setting = PreferenceManager.getDefaultSharedPreferences(this);
    		username = setting.getString("username", null);
    		apikey = setting.getString("apikey", null);
    	//	etShareText.setText(username + apikey);
    		btShare.setOnClickListener(new OnClickListener() 
    		{
				
				private String queryEncode;

				public void onClick(View v) {
					
//					text = etShareText.getText().toString()+"\n"+getText(R.string.device_tag);
					text = etShareText.getText().toString();


//					String query = "user_id="+ username + "&"
//							+"apikey="+ apikey + "&" 
//							+"url="+ url + "&"
//							+"title="+ title + "&"
//							+"text="+ text;
//					String query = endpoint
//							+"user_id="+ username + "&"
//							+"apikey="+ apikey + "&" 
//							+"url="+ url + "&"
//							+"title="+ title + "&"
//							+"text="+ text;
				    postParameters = new ArrayList<NameValuePair>();
				    postParameters.add(new BasicNameValuePair("user_id", username));
				    postParameters.add(new BasicNameValuePair("apikey", apikey));							
				    postParameters.add(new BasicNameValuePair("url", url));		
				    postParameters.add(new BasicNameValuePair("title", title));		
				    postParameters.add(new BasicNameValuePair("text", text));		

//					Toast.makeText(getApplicationContext(), url.toString(), Toast.LENGTH_LONG).show();		
//					TeamarksService.shareUrl(url.toString());

					TeamarksService ts = new TeamarksService();
					try {
						ts.shareUrl(endpoint,postParameters,"UTF-8");
					} catch (UnsupportedEncodingException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			});
    }
}
