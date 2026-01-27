import Foundation

/// Result of the consent request
public enum ConsentResult: Equatable {
    /// User accepted the consent request
    case accepted(attStatus: ATTStatus?)
    /// User declined the consent request
    case declined
    /// Consent was not required (user not in EEA region)
    case notRequired

    public static func == (lhs: ConsentResult, rhs: ConsentResult) -> Bool {
        switch (lhs, rhs) {
        case (.accepted(let lhsStatus), .accepted(let rhsStatus)):
            return lhsStatus == rhsStatus
        case (.declined, .declined):
            return true
        case (.notRequired, .notRequired):
            return true
        default:
            return false
        }
    }
}

/// App Tracking Transparency status
public enum ATTStatus: Equatable {
    case authorized
    case denied
    case restricted
    case notDetermined
}
