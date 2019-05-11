# GarlicWebview
A simple webview plugin for unity3d engine. 

Currently supports android only. iOS support will be implemented soon.

## Android

- This plugin uses [DialogFragment](https://developer.android.com/reference/android/app/DialogFragment) to show [Webview](https://developer.android.com/reference/android/webkit/WebView).
- You can modify Webview's configuration as you want with modifying code inside [GarlicWebdialogFragment.java's OnCreateView](https://github.com/GarlicDipping/GarlicWebview-Unity/blob/3d5aa6db210f0b28f5f98d9708f17a4aec27c314/GarlicWebview-Android/webview/src/main/java/com/tapas/garlic/plugin/webview/GarlicWebDialogFragment.java#L95) method.


## How to use

### Callback Receiver

If you want to receive callbacks from webview, implement <code>IGarlicWebviewCallback</code> interface.

<pre><code>
private class GarlicWebviewCallbackReceiver : IGarlicWebviewCallback
{
    public void onClose()
    {
      Debug.Log("GarlicWebview: onClose");
    }

    public void onLoadResource(string url)
    {
        Debug.Log("GarlicWebview: onLoadResource [" + url + "]");
    }

    public void onPageFinished(string url)
    {
        Debug.Log("GarlicWebview: onPageFinished [" + url + "]");
    }

    public void onPageStarted(string url)
    {
        Debug.Log("GarlicWebview: onPageStarted [" + url + "]");
    }

    public void onReceiverdError(int errorCode, string description, string failingUrl)
    {
        Debug.Log("GarlicWebview: onReceiverdError [" + errorCode + "][" + description + "][" + failingUrl + "]");
    }

    public void onShow()
    {
        Debug.Log("GarlicWebview: onShow");
    }
}
</code></pre>

### Show Webview

Simply call <code>GarlicWebview.Instance.Show()</code>.

<pre><code>

using Garlic.Plugins.Webview;

...

void Start()
{
    var callbackReceiver = new GarlicWebviewCallbackReceiver();
    //Initialization method will be automatically called when accesing GarlicWebview.Instance
    GarlicWebview.Instance.SetCallbackInterface(callbackReceiver);
    GarlicWebview.Instance.Show("Your URL Here");
}

...

</code></pre>

See GarlicWebviewSample project to learn more about this plugin. 
Tested on Samsung Galaxy s8, sample project built with Unity2017.4.26f1 LTS.

TODO
- iOS Support
