package com.tapas.garlic.plugin.test;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.EditText;

import com.tapas.garlic.plugin.webview.GarlicUtils;
import com.tapas.garlic.plugin.webview.GarlicWebDialogCallback;
import com.tapas.garlic.plugin.webview.GarlicWebDialogFragment;
import com.tapas.garlic.plugin.webview.GarlicWebDialogUnityBridge;

public class MainActivity extends AppCompatActivity {
    private static String TAG = "GarlicWebviewMainActivity";
    EditText editText_url;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        editText_url = findViewById(R.id.editText_url);
        findViewById(R.id.btn_openwebview).setOnClickListener(openWebviewListener);
    }

    View.OnClickListener openWebviewListener = new View.OnClickListener(){
        @Override
        public void onClick(View v) {
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            Fragment prev = getSupportFragmentManager().findFragmentByTag(GarlicWebDialogFragment.TAG);
            if (prev != null) {
                ft.remove(prev);
            }
            ft.addToBackStack(null);
            String url = editText_url.getText().toString();
            GarlicWebDialogUnityBridge.Initialize(new GarlicWebDialogCallback() {
                @Override
                public void onReceivedError(String message) {
                    Log.e(TAG, "Webview Error[" + message + "]");
                }

                @Override
                public void onPageStarted(String url) {
                    Log.d(TAG, "Webview onPageStarted[" + url + "]");
                }

                @Override
                public void onPageFinished(String url) {
                    Log.d(TAG, "Webview onPageFinished[" + url + "]");
                }

                @Override
                public void onShow() {
                    Log.d(TAG, "Webview onShow");
                }

                @Override
                public void onClose() {
                    Log.d(TAG, "Webview onClose");
                }
            });
            int px = GarlicUtils.dpToPx(MainActivity.this, 30);
            GarlicWebDialogUnityBridge.SetMargins(px, px, px, px);
            GarlicWebDialogUnityBridge.SetFixedRatio(16, 9);
            GarlicWebDialogUnityBridge.Show(MainActivity.this, url);
        }
    };
}
