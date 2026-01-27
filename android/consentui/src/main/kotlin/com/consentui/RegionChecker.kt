package com.consentui

import java.util.Locale

/**
 * Checks if the user is in a region that requires consent (EEA)
 */
object RegionChecker {

    /**
     * EEA countries (EU + EFTA + UK)
     */
    val eeaCountries: Set<String> = setOf(
        // EU Member States
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
        // EFTA countries (part of EEA)
        "IS", // Iceland
        "LI", // Liechtenstein
        "NO", // Norway
        // UK (post-Brexit, same GDPR-equivalent regulations)
        "GB", // United Kingdom
    )

    /**
     * Check if consent is required for the current user
     * @return true if user is in EEA region
     */
    fun isConsentRequired(): Boolean {
        val regionCode = currentRegionCode() ?: return true // Be safe if unknown
        return eeaCountries.contains(regionCode.uppercase())
    }

    /**
     * Get the current region code
     * @return ISO 3166-1 alpha-2 country code or null
     */
    fun currentRegionCode(): String? {
        return Locale.getDefault().country.takeIf { it.isNotEmpty() }
    }
}
