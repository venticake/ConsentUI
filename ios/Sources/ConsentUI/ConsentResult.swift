import Foundation

/// Result of the consent request
public enum ConsentResult: Equatable {
    /// User accepted the consent request
    case accepted(attStatus: ATTStatus?)
    /// User declined the consent request
    /// ATT is still requested and status is returned
    case declined(attStatus: ATTStatus?)
    /// Consent was not required (user not in EEA region)
    /// ATT is still requested and status is returned
    case notRequired(attStatus: ATTStatus?)

    public static func == (lhs: ConsentResult, rhs: ConsentResult) -> Bool {
        switch (lhs, rhs) {
        case (.accepted(let lhsStatus), .accepted(let rhsStatus)):
            return lhsStatus == rhsStatus
        case (.declined(let lhsStatus), .declined(let rhsStatus)):
            return lhsStatus == rhsStatus
        case (.notRequired(let lhsStatus), .notRequired(let rhsStatus)):
            return lhsStatus == rhsStatus
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
