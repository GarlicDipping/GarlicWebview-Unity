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
		public static GarlicWebview Instance
		{
			get
			{
				if (instance == null) { instance = new GarlicWebview(); }
				return instance;
			}
		}

		private static GarlicWebview instance;
		private IGarlicWebviewImpl impl;
		
		private GarlicWebview()
		{
#if UNITY_ANDROID
			impl = new GarlicWebviewAndroidImpl();
#elif UNITY_IOS
#endif
		}

		public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
		{
			impl.SetCallbackInterface(callbackInterface);
		}

		public void Show(string url)
		{
			if(impl != null)
			{
				impl.Show(url);
			}
		}

		public bool IsShowing()
		{
			if (impl != null)
			{
				return impl.IsShowing();
			}
			return false;
		}

		public void Close()
		{
			if(impl != null)
			{
				impl.Close();
			}
		}
	}

	internal interface IGarlicWebviewImpl
	{
		void Show(string url);
		bool IsShowing();
		void Close();
		void SetCallbackInterface(IGarlicWebviewCallback callback);
	}

	internal class GarlicWebviewAndroidImpl : IGarlicWebviewImpl
	{
		internal class CallbackBridge : AndroidJavaProxy
		{
			private IGarlicWebviewCallback callbackInterface;
			public CallbackBridge(IGarlicWebviewCallback callbackInterface) : base("com.tapas.garlic.plugin.webview.GarlicWebDialogCallback")
			{
				this.callbackInterface = callbackInterface;
			}

			public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
			{
				this.callbackInterface = callbackInterface;
			}

			public void onReceiverdError(string message)
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onReceivedError(message);
			}
			public void onPageStarted(string url)
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onPageStarted(url);
			}
			public void onPageFinished(string url)
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onPageFinished(url);
			}

			public void onLoadResource(string url)
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onLoadResource(url);
			}

			public void onShow()
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onShow();
			}
			public void onClose()
			{
				if (callbackInterface == null) { return; }
				callbackInterface.onClose();
			}
		}

		private static string fullClassName = "com.tapas.garlic.plugin.webview.GarlicWebDialogUnityBridge";
		private AndroidJavaClass pluginClass;
		private AndroidJavaObject unityActivity;
		private CallbackBridge callback;
		public GarlicWebviewAndroidImpl()
		{
			callback = new CallbackBridge(null);
			pluginClass = new AndroidJavaClass(fullClassName);
			pluginClass.CallStatic<bool>("Initialize", callback);
			unityActivity = GetUnityActivity();
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

		public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
		{
			callback.SetCallbackInterface(callbackInterface);
		}

		private AndroidJavaObject GetUnityActivity()
		{
			AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
			return activity;
		}
	}

}
