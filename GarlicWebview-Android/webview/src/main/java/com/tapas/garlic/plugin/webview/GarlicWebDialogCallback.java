package com.tapas.garlic.plugin.webview;

public interface GarlicWebDialogCallback {
    void onReceivedError(String message);
    void onPageStarted(String url);
    void onPageFinished(String url);

    void onShow();
    void onClose();
}
