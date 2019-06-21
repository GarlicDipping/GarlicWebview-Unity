package com.tapas.garlic.plugin.webview;

import android.app.Activity;
import android.app.Fragment;
import android.util.Log;

public class GarlicWebDialogUnityBridge
{
    private static String TAG = "GarlicWebDialogUnityBridge";
    private static GarlicWebDialogCallback callback = null;
    private static GarlicWebDialogOptions options = new GarlicWebDialogOptions();

    public static GarlicWebDialogCallback GetCallbackHandler() {
        return callback;
    }

    public static boolean Initialize(GarlicWebDialogCallback callback) {
        if(GarlicWebDialogUnityBridge.callback == null) {
            GarlicWebDialogUnityBridge.callback = callback;
            return true;
        }
        else {
            Log.w(GarlicWebDialogUnityBridge.TAG, "GarlicWebDialog already initialized!");
            return false;
        }
    }

    public static boolean Show(Activity parentActivity, String url) {
        if(GarlicWebDialogUnityBridge.callback == null) {
            //Not Initialized!!
            Log.w(GarlicWebDialogUnityBridge.TAG, "GarlicWebDialog not initialized...");
            return false;
        }
        GarlicWebDialogFragment.ShowDialog(parentActivity, url, options);
        return true;
    }

    public static void SetMargins(int left, int right, int top ,int bottom) {
        options.setMargins(new GarlicMargins(left, right, top, bottom));
    }

    public static void SetFixedRatio(int width, int height) {
        options.setFixedRatio(width, height);
    }

    public static void UnSetFixedRatio() {
        options.unsetFixedRatio();
    }

    public static boolean IsShowing(Activity parentActivity) {
        Fragment fragment = parentActivity.getFragmentManager()
                .findFragmentByTag(GarlicWebDialogFragment.TAG);
        if (fragment == null) {
            return false;
        }
        else {
            return true;
        }
    }

    public static void Close(Activity parentActivity) {
        GarlicWebDialogFragment.CloseDialog(parentActivity);
    }
}
