using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Garlic.Plugins.Webview
{
	public interface IGarlicWebviewCallback
	{
		void onReceivedError(string message);
		void onPageStarted(string url);
		void onPageFinished(string url);
		void onLoadResource(string url);

		void onShow();
		void onClose();
	}

	public class GarlicWebview
	{
		private class GarlicWebviewCallback : AndroidJavaProxy
		{
			private IGarlicWebviewCallback callbackInterface;
			public GarlicWebviewCallback(IGarlicWebviewCallback callbackInterface) : base("com.tapas.garlic.plugin.webview.GarlicWebDialogCallback")
			{
				this.callbackInterface = callbackInterface;
			}

			public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
			{
				this.callbackInterface = callbackInterface;
			}

			public void onReceiverdError(string message)
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onReceivedError(message);
			}
			public void onPageStarted(string url)
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onPageStarted(url);
			}
			public void onPageFinished(string url)
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onPageFinished(url);
			}

			public void onLoadResource(string url)
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onLoadResource(url);
			}

			public void onShow()
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onShow();
			}
			public void onClose()
			{
				if(callbackInterface == null) { return; }
				callbackInterface.onClose();
			}
		}

		public static GarlicWebview Instance
		{
			get
			{
				if (instance == null) { instance = new GarlicWebview(); }
				return instance;
			}
		}

		private static string fullClassName = "com.tapas.garlic.plugin.webview.GarlicWebDialogUnityBridge";
		private static GarlicWebview instance;
		private GarlicWebviewCallback callback;
		private AndroidJavaClass pluginClass;
		private AndroidJavaObject unityActivity;
		private GarlicWebview()
		{
			callback = new GarlicWebviewCallback(null);
			pluginClass = new AndroidJavaClass(fullClassName);
			pluginClass.CallStatic<bool>("Initialize", callback);
			unityActivity = GetUnityActivity();
		}

		public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
		{
			callback.SetCallbackInterface(callbackInterface);
		}

		public void Show(string url)
		{
			pluginClass.CallStatic<bool>("Show", unityActivity, url);
		}

		public bool IsShowing()
		{
			return pluginClass.CallStatic<bool>("IsShowing", unityActivity);
		}

		public void Close()
		{
			pluginClass.CallStatic("Close", unityActivity);
		}

		private AndroidJavaObject GetUnityActivity()
		{
			AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
			return activity;
		}
	}

}
