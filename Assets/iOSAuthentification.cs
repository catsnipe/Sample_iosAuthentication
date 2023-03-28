using UnityEngine;
using System.Runtime.InteropServices;
using System;

public class iOSAuthentification : MonoBehaviour
{
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    delegate void CallbackDelegate([MarshalAs(UnmanagedType.I4)] Int32 num);
    
    [DllImport("__Internal", EntryPoint = "registerAuthCallback")]
    static extern void RegisterAuthCallback([MarshalAs(UnmanagedType.FunctionPtr)] CallbackDelegate callback);

    [DllImport("__Internal", EntryPoint = "authentification")]
    static extern long Authentification(int languageNo);

    void Start()
    {
        RegisterAuthCallback(callback);
    }

    public void onPressButton()
    {
        Authentification(0);
    }

    [AOT.MonoPInvokeCallbackAttribute(typeof(CallbackDelegate))]
    static void callback(Int32 num)
    {
        Debug.Log($"call native code: {num}");
    }
}
