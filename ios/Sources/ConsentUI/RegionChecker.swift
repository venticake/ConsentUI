import Foundation

/// Checks if the user is in a region that requires consent (EEA)
public final class RegionChecker {

    /// EEA countries (EU + EFTA + UK)
    /// EU Member States
    private static let euCountries: Set<String> = [
        "AT", // Austria
        "BE", // Belgium
        "BG", // Bulgaria
        "HR", // Croatia
        "CY", // Cyprus
        "CZ", // Czech Republic
        "DK", // Denmark
        "EE", // Estonia
        "FI", // Finland
        "FR", // France
        "DE", // Germany
        "GR", // Greece
        "HU", // Hungary
        "IE", // Ireland
        "IT", // Italy
        "LV", // Latvia
        "LT", // Lithuania
        "LU", // Luxembourg
        "MT", // Malta
        "NL", // Netherlands
        "PL", // Poland
        "PT", // Portugal
        "RO", // Romania
        "SK", // Slovakia
        "SI", // Slovenia
        "ES", // Spain
        "SE", // Sweden
    ]

    /// EFTA countries (part of EEA)
    private static let eftaCountries: Set<String> = [
        "IS", // Iceland
        "LI", // Liechtenstein
        "NO", // Norway
    ]

    /// UK (post-Brexit, same GDPR-equivalent regulations)
    private static let ukCountries: Set<String> = [
        "GB", // United Kingdom
    ]

    /// All EEA region countries
    public static let eeaCountries: Set<String> = euCountries
        .union(eftaCountries)
        .union(ukCountries)

    /// Shared instance
    public static let shared = RegionChecker()

    private init() {}

    /// Check if consent is required for the current user
    /// - Returns: true if user is in EEA region
    public func isConsentRequired() -> Bool {
        guard let regionCode = currentRegionCode() else {
            // If we can't determine region, be safe and require consent
            return true
        }
        return Self.eeaCountries.contains(regionCode.uppercased())
    }

    /// Get the current region code
    /// - Returns: ISO 3166-1 alpha-2 country code or nil
    public func currentRegionCode() -> String? {
        if #available(iOS 16, *) {
            return Locale.current.region?.identifier
        } else {
            return Locale.current.regionCode
        }
    }
}
