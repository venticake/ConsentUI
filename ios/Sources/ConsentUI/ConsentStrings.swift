import Foundation

/// Localized strings for consent UI
enum ConsentStrings {
    static var title: String {
        NSLocalizedString(
            "consent_title",
            bundle: .module,
            comment: "Consent dialog title"
        )
    }

    static var message: String {
        NSLocalizedString(
            "consent_message",
            bundle: .module,
            comment: "Consent dialog message"
        )
    }

    static var allow: String {
        NSLocalizedString(
            "consent_allow",
            bundle: .module,
            comment: "Allow button text"
        )
    }

    static var decline: String {
        NSLocalizedString(
            "consent_decline",
            bundle: .module,
            comment: "Decline button text"
        )
    }
}
