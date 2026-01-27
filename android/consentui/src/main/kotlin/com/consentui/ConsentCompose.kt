package com.consentui

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight

/**
 * State holder for consent dialog in Compose
 * Survives configuration changes (screen rotation)
 */
class ConsentState(initialVisible: Boolean = false) {
    var isVisible by mutableStateOf(initialVisible)
        private set

    var result by mutableStateOf<ConsentResult?>(null)
        private set

    /**
     * Show consent dialog
     */
    fun show() {
        isVisible = true
    }

    /**
     * Show consent dialog if needed based on region
     */
    fun showIfNeeded() {
        if (RegionChecker.isConsentRequired()) {
            isVisible = true
        } else {
            result = ConsentResult.NotRequired
        }
    }

    /**
     * Hide consent dialog (internal use)
     */
    internal fun hide() {
        isVisible = false
    }

    /**
     * Set result (internal use)
     */
    internal fun setConsentResult(consentResult: ConsentResult) {
        result = consentResult
    }

    companion object {
        val Saver: Saver<ConsentState, Boolean> = Saver(
            save = { it.isVisible },
            restore = { ConsentState(it) }
        )
    }
}

/**
 * Remember consent state across recompositions and configuration changes
 */
@Composable
fun rememberConsentState(): ConsentState {
    return rememberSaveable(saver = ConsentState.Saver) { ConsentState() }
}

/**
 * Consent dialog Composable
 * @param state ConsentState to control dialog visibility
 * @param onResult Callback with the consent result
 */
@Composable
fun ConsentDialog(
    state: ConsentState,
    onResult: (ConsentResult) -> Unit
) {
    if (state.isVisible) {
        AlertDialog(
            onDismissRequest = { /* Prevent dismiss */ },
            title = {
                Text(text = stringResource(R.string.consent_title))
            },
            text = {
                Text(text = stringResource(R.string.consent_message))
            },
            confirmButton = {
                TextButton(
                    onClick = {
                        state.hide()
                        val result = ConsentResult.Accepted
                        state.setConsentResult(result)
                        onResult(result)
                    }
                ) {
                    Text(
                        text = stringResource(R.string.consent_allow),
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF007AFF) // iOS-style blue
                    )
                }
            },
            dismissButton = {
                TextButton(
                    onClick = {
                        state.hide()
                        val result = ConsentResult.Declined
                        state.setConsentResult(result)
                        onResult(result)
                    }
                ) {
                    Text(
                        text = stringResource(R.string.consent_decline),
                        color = Color(0xFF8E8E93) // Gray
                    )
                }
            }
        )
    }
}

/**
 * Consent dialog Composable with automatic region check
 * Shows dialog only if user is in EEA region
 * @param showIfNeeded If true, automatically shows based on region
 * @param onResult Callback with the consent result
 */
@Composable
fun ConsentDialogIfNeeded(
    showIfNeeded: Boolean,
    onResult: (ConsentResult) -> Unit
) {
    var hasChecked by rememberSaveable { mutableStateOf(false) }
    val state = rememberConsentState()

    if (showIfNeeded && !hasChecked) {
        hasChecked = true
        if (RegionChecker.isConsentRequired()) {
            state.show()
        } else {
            onResult(ConsentResult.NotRequired)
        }
    }

    ConsentDialog(state = state, onResult = onResult)
}
