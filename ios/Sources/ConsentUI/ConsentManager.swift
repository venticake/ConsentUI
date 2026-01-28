import UIKit

/// Main entry point for ConsentUI
public final class ConsentManager {

    /// Shared instance
    public static let shared = ConsentManager()

    private let regionChecker: RegionChecker
    private let attManager: ATTManager

    private init() {
        self.regionChecker = RegionChecker.shared
        self.attManager = ATTManager.shared
    }

    /// Request consent from the user
    /// Always shows the consent dialog regardless of region
    /// For non-EEA users, returns .notRequired regardless of user's choice
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - completion: Callback with the consent result
    public func requestConsent(
        from viewController: UIViewController,
        completion: @escaping (ConsentResult) -> Void
    ) {
        let isEEA = regionChecker.isConsentRequired()

        ConsentDialog.show(from: viewController) { [weak self] accepted in
            guard let self = self else { return }

            self.attManager.requestAuthorization { attStatus in
                if isEEA {
                    // EEA user: return based on their choice
                    if accepted {
                        completion(.accepted(attStatus: attStatus))
                    } else {
                        completion(.declined(attStatus: attStatus))
                    }
                } else {
                    // Non-EEA user: always return notRequired
                    completion(.notRequired(attStatus: attStatus))
                }
            }
        }
    }

    /// Request consent only if needed based on user's region
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - completion: Callback with the consent result
    public func requestConsentIfNeeded(
        from viewController: UIViewController,
        completion: @escaping (ConsentResult) -> Void
    ) {
        if regionChecker.isConsentRequired() {
            requestConsent(from: viewController, completion: completion)
        } else {
            // Not in EEA, consent dialog not required but still request ATT
            attManager.requestAuthorization { attStatus in
                completion(.notRequired(attStatus: attStatus))
            }
        }
    }

    /// Check if consent is required for current user
    /// - Returns: true if user is in EEA region
    public func isConsentRequired() -> Bool {
        return regionChecker.isConsentRequired()
    }

    /// Get current ATT status
    /// - Returns: Current ATT authorization status
    public func currentATTStatus() -> ATTStatus {
        return attManager.currentStatus()
    }
}
