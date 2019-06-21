using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Garlic.Plugins.Webview.Impl
{
#if UNITY_ANDROID 
	internal class GarlicWebviewAndroidImpl : IGarlicWebviewImpl
	{
		private class CallbackBridge : AndroidJavaProxy
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
			unityActivity = GetUnityActivity();
		}

		#region implementation

		public void Initialize()
		{
			//Do Nothing
			pluginClass.CallStatic<bool>("Initialize", callback);
		}

		public void SetMargins(int left, int right, int top, int bottom)
		{
			pluginClass.CallStatic("SetMargins", left, right, top, bottom);
		}

		public void SetFixedRatio(int width, int height)
		{
			pluginClass.CallStatic("SetFixedRatio", width, height);
		}

		public void UnsetFixedRatio()
		{
			pluginClass.CallStatic("UnsetFixedRatio");
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

		#endregion

		private AndroidJavaObject GetUnityActivity()
		{
			AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
			return activity;
		}		
	}
#endif
}