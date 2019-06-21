using Garlic.Plugins.Webview;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Garlic.Plugins.Webview
{
	public class GarlicWebviewSample : MonoBehaviour
	{
		public Text urlText;

		// Use this for initialization
		void Start()
		{
			GarlicWebview.Instance.SetCallbackInterface(new GarlicWebviewCallbackReceiver());
		}

		public void OnClickShowWebview()
		{
#if UNITY_ANDROID
			OnClickShowWebviewAndroid();
#elif UNITY_IOS
			OnClickShowWebviewiOS();
#else
			Debug.LogError("Unsupported Platform!");
#endif
		}

		private void OnClickShowWebviewAndroid()
		{
			int marginPx = GarlicAndroidUtils.dpToPx(30);
			GarlicWebview.Instance.SetMargins(marginPx, marginPx, marginPx, marginPx);
			GarlicWebview.Instance.SetFixedRatio(16, 9);
			GarlicWebview.Instance.ShowWebview(urlText.text);
		}

		private void OnClickShowWebviewiOS()
		{
			GarlicWebview.Instance.SetFixedRatio(16, 9);
			GarlicWebview.Instance.ShowWebview(urlText.text);
		}

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

			public void onReceivedError(string errorMessage)
			{
				Debug.Log("GarlicWebview: onReceivedError [" + errorMessage + "]");
			}

			public void onShow()
			{
				Debug.Log("GarlicWebview: onShow");
			}
		}
	}
}