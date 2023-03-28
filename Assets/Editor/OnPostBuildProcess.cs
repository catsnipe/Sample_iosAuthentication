using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using System.IO;
#if UNITY_IOS
using UnityEditor.iOS.Xcode;
#endif

public class OnPostBuildProcess
{
    [PostProcessBuild]
    public static void OnPostProcessBuild(BuildTarget buildTarget, string path)
    {
        if (buildTarget == BuildTarget.iOS)
        {
            processForiOS(path);
        }
    }

    static void processForiOS(string path)
    {
#if UNITY_IOS
        var plistPath = Path.Combine(path, "Info.plist");
        var plist = new PlistDocument();

        plist.ReadFromFile(plistPath);
        var root = plist.root;
        root.SetString("NSFaceIDUsageDescription", "認証に必要");
        plist.WriteToFile(plistPath);
#endif
    }
}
