using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

namespace Garlic.Plugins.Webview
{
	public interface IGarlicWebviewCallback
	{
		void onReceivedError(string message);
		void onPageStarted(string url);
		void onPageFinished(string url);

		void onShow();
		void onClose();
	}

	public class GarlicWebview : MonoBehaviour
	{
		private static GarlicWebview _instance;

		public static GarlicWebview Instance
		{
			get
			{
				if(_instance == null)
				{
					_instance = FindObjectOfType (typeof(GarlicWebview)) as GarlicWebview;
					if (_instance == null) 
					{
						var instanceObj = new GameObject("GarlicWebview");
						_instance = instanceObj.AddComponent<GarlicWebview>();
					}
				}

				return _instance;
			}
		}

		void Awake()
		{
			_instance = this;
		}

		private IGarlicWebviewImpl impl;
		
		private GarlicWebview()
		{
#if UNITY_ANDROID
			impl = new GarlicWebviewAndroidImpl();
#elif UNITY_IOS
			impl = new GarlicWebviewiOSImpl();
			impl.Initialize();
#endif
		}

		public void ShowWebview(string url)
		{
			if(impl != null)
			{
				impl.Show(url);
			}
		}

		public bool IsShowingWebview()
		{
			if (impl != null)
			{
				return impl.IsShowing();
			}
			return false;
		}

		public void CloseWebview()
		{
			if(impl != null)
			{
				impl.Close();
			}
		}

		public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
		{
			impl.SetCallbackInterface(callbackInterface);
		}

		#if UNITY_IOS

		[DllImport("__Internal")]
		internal static extern void Initialize();

		[DllImport("__Internal")]
		internal static extern void Show(string url);

		[DllImport("__Internal")]
		internal static extern void Close();

		[DllImport("__Internal")]
		internal static extern void Dispose();

		#region Callback from native

		void __fromnative_onReceiverdError(string message)
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onReceiverdError (message);
		}
		void __fromnative_onPageStarted(string url)
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onPageStarted (url);
		}
		void __fromnative_onPageFinished(string url)
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onPageFinished (url);
		}

		void __fromnative_onShow()
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onShow ();
		}
		void __fromnative_onClose()
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onClose ();
		}

		#endregion

		#endif
	}

	internal interface IGarlicWebviewImpl
	{
		void Initialize();
		void Show(string url);
		bool IsShowing();
		void Close();
		void SetCallbackInterface(IGarlicWebviewCallback callback);
	}

	internal class GarlicWebviewiOSImpl : IGarlicWebviewImpl
	{
		IGarlicWebviewCallback callbackInterface;

		public void Initialize()
		{
			GarlicWebview.Initialize ();
		}

		public void Show(string url)
		{
			GarlicWebview.Show (url);
		}

		public bool IsShowing()
		{
			return false;
		}

		public void Close()
		{
			GarlicWebview.Close ();
		}

		public void SetCallbackInterface(IGarlicWebviewCallback callbackInterface)
		{
			this.callbackInterface = callbackInterface;
		}

		public void __fromnative_onReceiverdError(string message)
		{
			if (callbackInterface == null) { return; }
			callbackInterface.onReceivedError(message);
		}
		public void __fromnative_onPageStarted(string url)
		{
			if (callbackInterface == null) { return; }
			callbackInterface.onPageStarted(url);
		}
		public void __fromnative_onPageFinished(string url)
		{
			if (callbackInterface == null) { return; }
			callbackInterface.onPageFinished(url);
		}

		public void __fromnative_onShow()
		{
			if (callbackInterface == null) { return; }
			callbackInterface.onShow();
		}
		public void __fromnative_onClose()
		{
			if (callbackInterface == null) { return; }
			callbackInterface.onClose();
		}
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

		public void Initialize()
		{
			//Do Nothing
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
