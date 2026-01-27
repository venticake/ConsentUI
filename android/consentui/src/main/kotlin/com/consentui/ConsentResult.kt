package com.consentui

/**
 * Result of the consent request
 */
sealed class ConsentResult {
    /** User accepted the consent request */
    object Accepted : ConsentResult()

    /** User declined the consent request */
    object Declined : ConsentResult()

    /** Consent was not required (user not in EEA region) */
    object NotRequired : ConsentResult()
}

/**
 * Callback interface for consent results
 */
interface ConsentCallback {
    fun onResult(result: ConsentResult)
}
