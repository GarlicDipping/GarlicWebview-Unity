using System;
using UnityEngine;

namespace Garlic.Plugins.Webview.Utils
{
	public static class GarlicUtils
	{
		public static float DPToPx(float dp) 
		{
			float px = dp * (Screen.dpi / 160f);
			return px;
		}

		#if UNITY_IOS

		/// <summary>
		/// for iOS
		/// </summary>
		/// <returns>iOS pt converted to px.</returns>
		/// <param name="pt">iOS Point value to convert into px.</param>
		public static float PtToPx(int pt)
		{
			return GarlicWebview.__IOS_PtToPx (pt);
		}

		#endif
	}
}

