import Foundation
import LocalAuthentication

public typealias CallbackDelegate = @convention(c) (Int32) -> Void

public class iOSAuthentification
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

    public static func canAuthentification()
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

    public static func authentification(languageNo: Int)
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

print("called canEvaluatePolicy")
        // Face ID, Touch IDが利用できるデバイスか確認する
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
print("called evaluatePolicy")
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
                            // Face IDが利用出来る
                            authCallbackDelegate?(1)
print("★★★★★★ [FACEID]")
                            break
                        case .touchID:
                            // Touch IDが利用できる
print("★★★★★★ [TOUCHID]")
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
print("★★★★★★ [FAILED]")
                        authCallbackDelegate?(0)
                    }
                }
            )
        }
        else
        {
            // Face ID, Touch IDが利用出来ない
print("★★★★★★ [CANNOT USE BIO]")
            authCallbackDelegate?(-1)
        }
    }
}

@_cdecl("registerCanAuthCallback")
public func registerCanAuthCallback(_ delegate: @escaping CallbackDelegate)
{
    return iOSAuthentification.registerCanAuthCallback(delegate)
}

@_cdecl("registerAuthCallback")
public func registerAuthCallback(_ delegate: @escaping CallbackDelegate)
{
    return iOSAuthentification.registerAuthCallback(delegate)
}

@_cdecl("canAuthentification")
public func canAuthentification()
{
    return iOSAuthentification.canAuthentification()
}

@_cdecl("authentification")
public func authentification(_ languageNo: Int)
{
    return iOSAuthentification.authentification(languageNo: languageNo)
}
