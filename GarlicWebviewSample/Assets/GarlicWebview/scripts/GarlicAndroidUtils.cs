using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class GarlicAndroidUtils
{
	private static string utilClassName = "com.tapas.garlic.plugin.webview.GarlicUtils";
	public static int dpToPx(float dp)
	{
#if UNITY_ANDROID
		AndroidJavaClass activityClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
		AndroidJavaObject activity = activityClass.GetStatic<AndroidJavaObject>("currentActivity");
		AndroidJavaClass utilClass = new AndroidJavaClass(utilClassName);
		return utilClass.CallStatic<int>("dpToPx", activity, dp);
#else
		Debug.LogWarning("This method can be called on Android environment only!");
		return dp;
#endif
	}
}
