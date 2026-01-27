package com.consentui.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.consentui.ConsentDialog
import com.consentui.ConsentResult
import com.consentui.rememberConsentState

class ComposeActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ConsentExampleScreen()
                }
            }
        }
    }
}

@Composable
fun ConsentExampleScreen() {
    val consentState = rememberConsentState()
    var statusText by remember { mutableStateOf("Consent Status: Not requested") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = statusText,
            style = MaterialTheme.typography.bodyLarge
        )

        Spacer(modifier = Modifier.height(24.dp))

        Button(onClick = { consentState.show() }) {
            Text(text = stringResource(R.string.request_consent))
        }

        Spacer(modifier = Modifier.height(12.dp))

        Button(onClick = { consentState.showIfNeeded() }) {
            Text(text = stringResource(R.string.request_if_needed))
        }
    }

    // Consent Dialog
    ConsentDialog(state = consentState) { result ->
        statusText = when (result) {
            is ConsentResult.Accepted -> "Consent: Accepted"
            is ConsentResult.Declined -> "Consent: Declined"
            is ConsentResult.NotRequired -> "Consent: Not Required (Not in EEA)"
        }
    }

    // Handle NotRequired result from showIfNeeded
    consentState.result?.let { result ->
        if (result is ConsentResult.NotRequired && statusText != "Consent: Not Required (Not in EEA)") {
            statusText = "Consent: Not Required (Not in EEA)"
        }
    }
}
