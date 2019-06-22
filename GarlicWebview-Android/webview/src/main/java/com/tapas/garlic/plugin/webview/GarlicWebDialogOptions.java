package com.tapas.garlic.plugin.webview;

import android.util.Log;

public class GarlicWebDialogOptions {
    private final String TAG = "GarlicWebDialogOptions";

    private GarlicMargins margins;
    private boolean useFixedRatio;
    private int ratioWidth;
    private int ratioHeight;

    public GarlicWebDialogOptions() {
        margins = new GarlicMargins(0, 0, 0, 0);
        useFixedRatio = false;
        ratioWidth = 0;
        ratioHeight = 0;
    }

    public GarlicMargins setMargins(GarlicMargins margins) {
        this.margins = margins;
        return this.margins;
    }

    public GarlicMargins getMargins() {
        return margins;
    }

    public void unsetFixedRatio() {
        this.useFixedRatio = false;
        this.ratioWidth = 0;
        this.ratioHeight = 0;
    }

    public void setFixedRatio(int ratioWidth, int ratioHeight) {
        this.useFixedRatio = true;
        this.ratioWidth = ratioWidth;
        this.ratioHeight = ratioHeight;
    }

    public boolean shouldUseFixedRatio() {
        return useFixedRatio;
    }

    /**
      * @return RatioWidth / RatioHeight, -1 if invalid
     */
    public int getRatioWidth() {
        if(useFixedRatio == false) {
            Log.e(TAG, "UseFixedRatio is false. returning -1!");
            return -1;
        }
        else if(ratioHeight == 0 || ratioWidth == 0) {
            Log.e(TAG, "Ratio values should use non-zero values. returning -1!");
            return -1;
        }
        return ratioWidth;
    }

    public int getRatioHeight() {
        if(useFixedRatio == false) {
            Log.e(TAG, "UseFixedRatio is false. returning -1!");
            return -1;
        }
        else if(ratioHeight == 0) {
            Log.e(TAG, "Ratio values should use non-zero values. returning -1!");
            return -1;
        }
        return ratioHeight;
    }

    public String getRatioString() {
        return getRatioWidth() + ":" + getRatioHeight();
    }
}
