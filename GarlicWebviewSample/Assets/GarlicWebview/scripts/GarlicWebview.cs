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
#endif
			impl.Initialize();
		}

		public void SetMargins(int left, int right, int top, int bottom)
		{
			if (impl != null)
			{
				impl.SetMargins(left, right, top, bottom);
			}
		}

		public void SetFixedRatio(int width, int height)
		{
			if (impl != null)
			{
				impl.SetFixedRatio(width, height);
			}
		}

		public void UnsetFixedRatio()
		{
			if (impl != null)
			{
				impl.UnsetFixedRatio();
			}
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

		void __fromnative_onShow(string empty_msg)
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onShow ();
		}
		void __fromnative_onClose(string empty_msg)
		{
			(impl as GarlicWebviewiOSImpl).__fromnative_onClose ();
		}

		#endregion

		#endif
	}

	internal interface IGarlicWebviewImpl
	{
		void Initialize();
		void SetMargins(int left, int right, int top, int bottom);
		void SetFixedRatio(int width, int height);
		void UnsetFixedRatio();
		void Show(string url);
		bool IsShowing();		
		void Close();
		void SetCallbackInterface(IGarlicWebviewCallback callback);
	}
}
