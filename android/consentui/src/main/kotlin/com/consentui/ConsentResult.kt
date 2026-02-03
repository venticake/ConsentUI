package com.consentui

/**
 * Enum representation of consent result types for Java interoperability.
 * Use this enum in Java switch statements for easier handling.
 */
enum class ConsentResultType {
    ACCEPTED,
    DECLINED,
    NOT_REQUIRED
}

/**
 * Result of the consent request
 */
sealed class ConsentResult {
    /** The type of this result as an enum for Java interoperability */
    abstract val type: ConsentResultType

    /** User accepted the consent request */
    object Accepted : ConsentResult() {
        override val type: ConsentResultType = ConsentResultType.ACCEPTED
    }

    /** User declined the consent request */
    object Declined : ConsentResult() {
        override val type: ConsentResultType = ConsentResultType.DECLINED
    }

    /** Consent was not required (user not in EEA region) */
    object NotRequired : ConsentResult() {
        override val type: ConsentResultType = ConsentResultType.NOT_REQUIRED
    }

    companion object {
        /**
         * Creates a ConsentResult from the given type enum.
         * Useful for Java code that needs to convert from enum to sealed class.
         */
        @JvmStatic
        fun fromType(type: ConsentResultType): ConsentResult = when (type) {
            ConsentResultType.ACCEPTED -> Accepted
            ConsentResultType.DECLINED -> Declined
            ConsentResultType.NOT_REQUIRED -> NotRequired
        }
    }
}

/**
 * Callback interface for consent results
 */
interface ConsentCallback {
    fun onResult(result: ConsentResult)
}
