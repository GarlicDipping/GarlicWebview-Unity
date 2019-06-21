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
	}
}

