using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Garlic.Plugins.Webview
{
#if UNITY_IOS
	internal class GarlicWebviewiOSImpl : IGarlicWebviewImpl
	{
		IGarlicWebviewCallback callbackInterface;

		public void Initialize()
		{
			GarlicWebview.Initialize();
		}

		public void Show(string url)
		{
			GarlicWebview.Show(url);
		}

		public bool IsShowing()
		{
			return false;
		}

		public void Close()
		{
			GarlicWebview.Close();
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