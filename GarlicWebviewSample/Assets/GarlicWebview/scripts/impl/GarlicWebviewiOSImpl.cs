using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Garlic.Plugins.Webview.Impl
{
#if UNITY_IOS
	internal class GarlicWebviewiOSImpl : IGarlicWebviewImpl
	{
		IGarlicWebviewCallback callbackInterface;

		public void Initialize()
		{
			GarlicWebview.__IOS_Initialize();
		}

		public void SetMargins(int left, int right, int top, int bottom)
		{
			GarlicWebview.__IOS_SetMargins (left, right, top, bottom);
		}

		public void SetFixedRatio(int width, int height)
		{
			GarlicWebview.__IOS_SetFixedRatio (width, height);
		}

		public void UnsetFixedRatio()
		{
			GarlicWebview.__IOS_UnsetFixedRatio ();
		}

		public void Show(string url)
		{
			GarlicWebview.__IOS_Show(url);
		}

		public bool IsShowing()
		{
			return GarlicWebview.__IOS_IsShowing();
		}

		public void Close()
		{
			GarlicWebview.__IOS_Close();
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
#endif
}