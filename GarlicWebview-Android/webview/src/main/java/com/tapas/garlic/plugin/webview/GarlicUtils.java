package com.tapas.garlic.plugin.webview;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.util.TypedValue;

public class GarlicUtils {
    /**
     * Returns pixel value from dp.
     * @param parentActivity
     * @param dp
     * @return
     */
    public static int dpToPx(Activity parentActivity, float dp) {
        DisplayMetrics dm = parentActivity.getResources().getDisplayMetrics();
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, dm);
    }
}
