import Foundation

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

/// Manages App Tracking Transparency (ATT) requests
/// Only available on iOS 14+
public final class ATTManager {

    public static let shared = ATTManager()

    private init() {}

    /// Request ATT authorization
    /// - Parameter completion: Callback with the ATT status
    public func requestAuthorization(completion: @escaping (ATTStatus) -> Void) {
        #if canImport(AppTrackingTransparency)
        if #available(iOS 14, *) {
            // ATT requires the app to be fully active before showing the dialog
            // Adding a small delay ensures the UI is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        completion(status.toATTStatus())
                    }
                }
            }
        } else {
            // iOS 13 doesn't have ATT, consider it authorized
            completion(.authorized)
        }
        #else
        completion(.authorized)
        #endif
    }

    /// Get current ATT status without prompting
    /// - Returns: Current ATT status
    public func currentStatus() -> ATTStatus {
        #if canImport(AppTrackingTransparency)
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus.toATTStatus()
        }
        #endif
        return .authorized
    }
}

#if canImport(AppTrackingTransparency)
@available(iOS 14, *)
extension ATTrackingManager.AuthorizationStatus {
    func toATTStatus() -> ATTStatus {
        switch self {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
}
#endif
