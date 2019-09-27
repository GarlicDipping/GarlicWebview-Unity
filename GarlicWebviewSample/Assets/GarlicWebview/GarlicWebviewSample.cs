using Garlic.Plugins.Webview;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Garlic.Plugins.Webview.Utils;

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
			int marginPx = (int)GarlicUtils.DPToPx (30f);
			#elif UNITY_IOS
			int marginPx = (int)GarlicUtils.PtToPx(50);
			#endif

			GarlicWebview.Instance.SetMargins(marginPx, marginPx, marginPx, marginPx);
			GarlicWebview.Instance.SetFixedRatio(2, 1);
			GarlicWebview.Instance.Show(urlText.text);
		}

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
	}
}