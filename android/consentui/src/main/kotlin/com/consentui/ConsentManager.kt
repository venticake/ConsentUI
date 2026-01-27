package com.consentui

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity

/**
 * Main entry point for ConsentUI
 */
object ConsentManager {

    /**
     * Request consent from the user (Activity)
     * Always shows the consent dialog regardless of region
     * @param activity The activity to show dialog from (must be FragmentActivity)
     * @param callback Callback with the consent result
     */
    fun requestConsent(activity: FragmentActivity, callback: ConsentCallback) {
        ConsentDialog.show(activity) { accepted ->
            if (accepted) {
                callback.onResult(ConsentResult.Accepted)
            } else {
                callback.onResult(ConsentResult.Declined)
            }
        }
    }

    /**
     * Request consent from the user (Fragment)
     * Always shows the consent dialog regardless of region
     * @param fragment The fragment to show dialog from
     * @param callback Callback with the consent result
     */
    fun requestConsent(fragment: Fragment, callback: ConsentCallback) {
        ConsentDialog.show(fragment) { accepted ->
            if (accepted) {
                callback.onResult(ConsentResult.Accepted)
            } else {
                callback.onResult(ConsentResult.Declined)
            }
        }
    }

    /**
     * Request consent only if needed based on user's region (Activity)
     * @param activity The activity to show dialog from
     * @param callback Callback with the consent result
     */
    fun requestConsentIfNeeded(activity: FragmentActivity, callback: ConsentCallback) {
        if (RegionChecker.isConsentRequired()) {
            requestConsent(activity, callback)
        } else {
            callback.onResult(ConsentResult.NotRequired)
        }
    }

    /**
     * Request consent only if needed based on user's region (Fragment)
     * @param fragment The fragment to show dialog from
     * @param callback Callback with the consent result
     */
    fun requestConsentIfNeeded(fragment: Fragment, callback: ConsentCallback) {
        if (RegionChecker.isConsentRequired()) {
            requestConsent(fragment, callback)
        } else {
            callback.onResult(ConsentResult.NotRequired)
        }
    }

    /**
     * Check if consent is required for current user
     * @return true if user is in EEA region
     */
    fun isConsentRequired(): Boolean {
        return RegionChecker.isConsentRequired()
    }

    // Kotlin-friendly lambda versions

    /**
     * Request consent from the user (Activity) - Kotlin lambda version
     */
    inline fun requestConsent(activity: FragmentActivity, crossinline onResult: (ConsentResult) -> Unit) {
        requestConsent(activity, object : ConsentCallback {
            override fun onResult(result: ConsentResult) {
                onResult(result)
            }
        })
    }

    /**
     * Request consent from the user (Fragment) - Kotlin lambda version
     */
    inline fun requestConsent(fragment: Fragment, crossinline onResult: (ConsentResult) -> Unit) {
        requestConsent(fragment, object : ConsentCallback {
            override fun onResult(result: ConsentResult) {
                onResult(result)
            }
        })
    }

    /**
     * Request consent if needed (Activity) - Kotlin lambda version
     */
    inline fun requestConsentIfNeeded(activity: FragmentActivity, crossinline onResult: (ConsentResult) -> Unit) {
        requestConsentIfNeeded(activity, object : ConsentCallback {
            override fun onResult(result: ConsentResult) {
                onResult(result)
            }
        })
    }

    /**
     * Request consent if needed (Fragment) - Kotlin lambda version
     */
    inline fun requestConsentIfNeeded(fragment: Fragment, crossinline onResult: (ConsentResult) -> Unit) {
        requestConsentIfNeeded(fragment, object : ConsentCallback {
            override fun onResult(result: ConsentResult) {
                onResult(result)
            }
        })
    }
}
