package com.tapas.garlic.plugin.webview;

public interface GarlicWebDialogCallback {
    void onReceiverdError(int errorCode, String description, String failingUrl);
    void onPageStarted(String url);
    void onPageFinished(String url);
    void onLoadResource(String url);

    void onShow();
    void onClose();
}
