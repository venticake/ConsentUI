package com.consentui

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity

/**
 * AlertDialog wrapper for consent dialog
 */
object ConsentDialog {

    /**
     * Show consent dialog from an Activity
     * @param activity The activity to show dialog from (must be FragmentActivity)
     * @param onResult Callback with user's choice (true = accepted, false = declined)
     */
    fun show(activity: FragmentActivity, onResult: (Boolean) -> Unit) {
        ConsentDialogFragment.show(activity, onResult)
    }

    /**
     * Show consent dialog from a Fragment
     * @param fragment The fragment to show dialog from
     * @param onResult Callback with user's choice (true = accepted, false = declined)
     */
    fun show(fragment: Fragment, onResult: (Boolean) -> Unit) {
        val activity = fragment.requireActivity()
        ConsentDialogFragment.show(activity, onResult)
    }
}
