package com.consentui

import android.app.Dialog
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentActivity

/**
 * DialogFragment for consent dialog - survives configuration changes
 */
class ConsentDialogFragment : DialogFragment() {

    private var onResultCallback: ((Boolean) -> Unit)? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Prevent dismissal by back button or outside touch
        isCancelable = false
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val dialog = AlertDialog.Builder(requireContext())
            .setTitle(R.string.consent_title)
            .setMessage(R.string.consent_message)
            .setCancelable(false)
            .setPositiveButton(R.string.consent_allow) { d, _ ->
                d.dismiss()
                onResultCallback?.invoke(true)
            }
            .setNegativeButton(R.string.consent_decline) { d, _ ->
                d.dismiss()
                onResultCallback?.invoke(false)
            }
            .create()

        // Prevent dismissal by touching outside the dialog
        dialog.setCanceledOnTouchOutside(false)

        dialog.setOnShowListener {
            // Style the Allow button - bold and blue
            dialog.getButton(AlertDialog.BUTTON_POSITIVE)?.apply {
                setTypeface(typeface, Typeface.BOLD)
                setTextColor(Color.parseColor("#007AFF"))
            }
            // Style the Decline button - gray
            dialog.getButton(AlertDialog.BUTTON_NEGATIVE)?.apply {
                setTextColor(Color.parseColor("#8E8E93"))
            }
        }

        return dialog
    }

    fun setOnResultCallback(callback: (Boolean) -> Unit) {
        onResultCallback = callback
    }

    companion object {
        private const val TAG = "ConsentDialogFragment"

        fun show(activity: FragmentActivity, onResult: (Boolean) -> Unit) {
            // Check if dialog is already showing
            val existing = activity.supportFragmentManager.findFragmentByTag(TAG)
            if (existing != null) {
                (existing as? ConsentDialogFragment)?.setOnResultCallback(onResult)
                return
            }

            val fragment = ConsentDialogFragment()
            fragment.setOnResultCallback(onResult)
            fragment.show(activity.supportFragmentManager, TAG)
        }
    }
}
