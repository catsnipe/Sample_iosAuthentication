import Foundation
import LocalAuthentication

public typealias CallbackDelegate = @convention(c) (Int32) -> Void

public class iOSAuthentication
{
    static private var canAuthCallbackDelegate: CallbackDelegate? = nil;
    static private var authCallbackDelegate: CallbackDelegate? = nil;

    public static func registerCanAuthCallback(_ delegate: @escaping CallbackDelegate)
    {
        canAuthCallbackDelegate = delegate
    }

    public static func registerAuthCallback(_ delegate: @escaping CallbackDelegate)
    {
        authCallbackDelegate = delegate
    }

    public static func canAuthentication()
    {
        let context = LAContext()
        var error: NSError?

        // Face ID, Touch IDが利用できるデバイスか確認する
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            canAuthCallbackDelegate?(1)
        }
        else
        {
            canAuthCallbackDelegate?(0)
        }
    }

    public static func authentication(languageNo: Int)
    {
        var description: String = "Sign-in"
        let context = LAContext()
        if (languageNo == 0)
        {
            context.localizedFallbackTitle = "他の方法を試す"
            description = "サインイン"
        }
        else
        {
            context.localizedFallbackTitle = "Try another sign-in"
        }
        var error: NSError?

//print("called canEvaluatePolicy")
        // Face ID, Touch IDが利用できるデバイスか確認する
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
//print("called evaluatePolicy")
            // Face ID, Touch IDが利用できる場合は認証用ダイアログを表示
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description,
                reply:
                {
                    success, evaluateError in
                    if (success)
                    {
                        // 認証成功
                        switch context.biometryType
                        {
                        case .faceID:
                            authCallbackDelegate?(1)
//print("★★★★★★ [FACEID]")
                            break
                        case .touchID:
//print("★★★★★★ [TOUCHID]")
                            authCallbackDelegate?(1)
                            break
                        case .none:
                            // Face ID, Touch IDが利用出来ない (unknown)
                            authCallbackDelegate?(0)
                            break
                        @unknown default:
                            authCallbackDelegate?(0)
                            break
                        }
                    }
                    else
                    {
                        // 認証失敗
//print("★★★★★★ [FAILED]")
                        authCallbackDelegate?(0)
                    }
                }
            )
        }
        else
        {
            // Face ID, Touch IDが利用出来ない
//print("★★★★★★ [CANNOT USE BIO]")
            authCallbackDelegate?(-1)
        }
    }
}

@_cdecl("registerCanAuthCallback")
public func registerCanAuthCallback(_ delegate: @escaping CallbackDelegate)
{
    return iOSAuthentication.registerCanAuthCallback(delegate)
}

@_cdecl("registerAuthCallback")
public func registerAuthCallback(_ delegate: @escaping CallbackDelegate)
{
    return iOSAuthentication.registerAuthCallback(delegate)
}

@_cdecl("canAuthentication")
public func canAuthentication()
{
    return iOSAuthentication.canAuthentication()
}

@_cdecl("authentication")
public func authentication(_ languageNo: Int)
{
    return iOSAuthentication.authentication(languageNo: languageNo)
}
