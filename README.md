# GarlicWebview
A simple webview plugin for unity3d engine. 

Supports both Android and iOS.

## Install

Download [GarlicWebview-Unity.unitypackage](https://github.com/GarlicDipping/GarlicWebview-Unity/raw/master/GarlicWebview-Unity.unitypackage) file and import, then enjoy!

## Android

- This plugin uses [DialogFragment](https://developer.android.com/reference/android/app/DialogFragment) to show [Webview](https://developer.android.com/reference/android/webkit/WebView).
- Webview layout is built using [ConstraintLayout](https://developer.android.com/reference/android/support/constraint/ConstraintLayout), which means you need to define depencency on gradle file like this : 
<pre><code>
dependencies {
    ...
    
    implementation 'com.android.support.constraint:constraint-layout:1.1.3'
    
    ...
}
</code></pre>

  - In Unity, you need to add gradle template file. See <strong>'Providing a custom build.gradle template'</strong> paragraph on [Unity's documentation page.](https://docs.unity3d.com/Manual/android-gradle-overview.html) Also, you can check [sample code's main template file.](https://github.com/GarlicDipping/GarlicWebview-Unity/blob/development/GarlicWebviewSample/Assets/Plugins/Android/mainTemplate.gradle)
- You can modify Webview's configuration as you want with modifying code inside [GarlicWebdialogFragment.java's OnCreateView](https://github.com/GarlicDipping/GarlicWebview-Unity/blob/3d5aa6db210f0b28f5f98d9708f17a4aec27c314/GarlicWebview-Android/webview/src/main/java/com/tapas/garlic/plugin/webview/GarlicWebDialogFragment.java#L95) method.

## iOS

- Requires iOS version >= 9.0
- This plugin uses [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) and built using Swift 5.

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

    public void onPageFinished(string url)
    {
        Debug.Log("GarlicWebview: onPageFinished [" + url + "]");
    }

    public void onPageStarted(string url)
    {
        Debug.Log("GarlicWebview: onPageStarted [" + url + "]");
    }

    public void onReceivedError(string errorMessage)
    {
        Debug.Log("GarlicWebview: onReceivedError [" + errorMessage + "]");
    }

    public void onShow()
    {
        Debug.Log("GarlicWebview: onShow");
    }
}
</code></pre>

Then, you can register your interface instance with <code>GarlicWebview.Instance.SetCallbackInterface()</code> method.
<pre><code>
//Instantiate your callback receiver.
var callbackReceiver = new GarlicWebviewCallbackReceiver();
//...Then set receiver with SetCallbackInterface().
//Note : Initialization method will be automatically called when accesing GarlicWebview.Instance
GarlicWebview.Instance.SetCallbackInterface(callbackReceiver);
</code></pre>

### Webview Options

Functions below are used to set options for webview.
You should call those functions <strong>after</strong> initialize webview, and <strong>before</strong> showing webview.

#### SetMargins(int left, int right, int top, int bottom)

Sets margins around webview. Units are in px.
Example : 
<pre><code>
int marginPx = (int)GarlicUtils.DPToPx (30f);
GarlicWebview.Instance.SetMargins(marginPx, marginPx, marginPx, marginPx);
</code></pre>

#### SetFixedRatio(int width, int height)

Webview will be shown in Fixed Ratio(Width:Height). Margins will also still be applied.

#### UnsetFixedRatio()

Call this function if you want to unset fixed ratio options.

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
