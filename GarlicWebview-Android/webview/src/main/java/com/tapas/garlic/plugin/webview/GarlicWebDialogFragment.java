package com.tapas.garlic.plugin.webview;
/*
 * Copyright (C) 2015 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;

/** A DialogFragment that shows a web view. */
public class GarlicWebDialogFragment extends DialogFragment {
    public static final String TAG = "WebDialogFragment";

    private static final String URL = "URL";
    private FrameLayout layout;
    private WebView mWebView;
    private Button mWebViewClose;

    /**
     * Create a new WebDialogFragment to show a particular web page.
     *
     * @param url The URL of the content to show.
     */

    public static GarlicWebDialogFragment ShowDialog(final Activity activity, String url) {
        FragmentTransaction ft = activity.getFragmentManager().beginTransaction();
        //이미 다이얼로그가 보여지고 있었다면 Destroy & Re-Show
        Fragment prev = activity.getFragmentManager().findFragmentByTag(TAG);
        if (prev != null) {
            ft.remove(prev);
        }

        //Create dialog frag and show it
        final GarlicWebDialogFragment f = new GarlicWebDialogFragment();
        Bundle args = new Bundle();
        args.putString(URL, url);
        f.setArguments(args);
        //show() 호출시 ft.commit이 자동적으로 호출됨.
        f.show(ft, TAG);
        GarlicWebDialogUnityBridge.GetCallbackHandler().onShow();
        return f;
    }

    public static void CloseDialog(Activity activity) {
        Fragment fragment = activity.getFragmentManager()
                .findFragmentByTag(GarlicWebDialogFragment.TAG);
        if(fragment != null) {
            FragmentTransaction ft = activity.getFragmentManager().beginTransaction();
            ft.remove(fragment);
            ft.commit();
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        int style = DialogFragment.STYLE_NO_TITLE;
        setStyle(style, R.style.GarlicWebview_Dialog_Theme);
    }

    @Nullable
    @Override
    public View onCreateView(
            LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.layout_webview_dialoguefragment, container, false);

        layout = rootView.findViewById(R.id.root);
        mWebView = rootView.findViewById(R.id.webview); //new WebView(activity);
        mWebViewClose = rootView.findViewById(R.id.webview_exit);
        mWebViewClose.setOnClickListener(onClickWebViewExit);

        mWebView.setFocusable(true);
        mWebView.setFocusableInTouchMode(true);

        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl)
            {
                mWebView.loadUrl("about:blank");
                GarlicWebDialogUnityBridge.GetCallbackHandler().onReceiverdError(errorCode, description, failingUrl);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                GarlicWebDialogUnityBridge.GetCallbackHandler().onPageStarted(url);
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                GarlicWebDialogUnityBridge.GetCallbackHandler().onPageFinished(url);
            }

            @Override
            public void onLoadResource(WebView view, String url) {
                GarlicWebDialogUnityBridge.GetCallbackHandler().onLoadResource(url);
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url)
            {
                view.loadUrl(url);
                return true;
            }
        });

        WebSettings webSettings = mWebView.getSettings();
        webSettings.setDisplayZoomControls(false);
        webSettings.setSupportZoom(false);
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setUseWideViewPort(true);
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);

        String url = getArguments().getString(URL);
        mWebView.loadUrl(url);

        return rootView;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mWebView != null) {
            mWebView.stopLoading();
            mWebView.destroy();
            mWebView = null;
            if(isRemoving()) {
                GarlicWebDialogUnityBridge.GetCallbackHandler().onClose();
            }
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        // Ensure the dialog is fullscreen, even if the webview doesn't have its content yet.
        getDialog().getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        getDialog().getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
    }

    View.OnClickListener onClickWebViewExit = new View.OnClickListener(){
        @Override
        public void onClick(View view) {
            //dismiss();
            CloseDialog(getActivity());
        }
    };
}