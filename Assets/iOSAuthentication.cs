using UnityEngine;
using System.Runtime.InteropServices;
using System;

public class iOSAuthentication : MonoBehaviour
{
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    delegate void CallbackDelegate([MarshalAs(UnmanagedType.I4)] Int32 num);
    
    [DllImport("__Internal", EntryPoint = "registerAuthCallback")]
    static extern void RegisterAuthCallback([MarshalAs(UnmanagedType.FunctionPtr)] CallbackDelegate callback);

    [DllImport("__Internal", EntryPoint = "authentication")]
    static extern long Authentication(int languageNo);

    void Start()
    {
        RegisterAuthCallback(callback);
    }

    public void onPressButton()
    {
        Authentication(0);
    }

    [AOT.MonoPInvokeCallbackAttribute(typeof(CallbackDelegate))]
    static void callback(Int32 num)
    {
        Debug.Log($"call native code: {num}");
    }
}
