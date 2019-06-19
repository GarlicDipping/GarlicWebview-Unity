using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;

public static class GarlicWebviewUnityBridgePostProcessor {
	[PostProcessBuild]
	public static void OnPostProcessBuild(BuildTarget buildTarget, string buildPath) {
		if(buildTarget == BuildTarget.iOS) {
			// We need to construct our own PBX project path that corrently refers to the Bridging header
			// var projPath = PBXProject.GetPBXProjectPath(buildPath);
			var projPath = buildPath + "/Unity-iPhone.xcodeproj/project.pbxproj";
			var proj = new PBXProject();
			proj.ReadFromFile(projPath);

			var targetGuid = proj.TargetGuidByName(PBXProject.GetUnityTargetName());

			//// Configure build settings
			proj.AddBuildProperty(targetGuid, "SWIFT_OBJC_BRIDGING_HEADER", "Libraries/GarlicWebview/Plugins/iOS/GarlicWebviewUnityBridge/Classes/GarlicWebviewUnityBridge-Bridging-Header.h");
			proj.AddBuildProperty(targetGuid, "SWIFT_OBJC_INTERFACE_HEADER_NAME", "GarlicWebviewUnityBridge/GarlicWebviewUnityBridge-Swift.h");
			proj.SetBuildProperty (targetGuid, "SWIFT_VERSION", "5.0");
			//proj.AddBuildProperty(targetGuid, "LD_RUNPATH_SEARCH_PATHS", "@executable_path/Frameworks");

			proj.WriteToFile(projPath);
		}
	}
}