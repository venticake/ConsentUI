package com.consentui.example

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.consentui.ConsentManager
import com.consentui.ConsentResult
import com.consentui.example.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupButtons()
    }

    private fun setupButtons() {
        binding.requestConsentButton.setOnClickListener {
            ConsentManager.requestConsent(this) { result ->
                updateStatus(result)
            }
        }

        binding.requestIfNeededButton.setOnClickListener {
            ConsentManager.requestConsentIfNeeded(this) { result ->
                updateStatus(result)
            }
        }

        binding.openComposeButton.setOnClickListener {
            startActivity(Intent(this, ComposeActivity::class.java))
        }
    }

    private fun updateStatus(result: ConsentResult) {
        val statusText = when (result) {
            is ConsentResult.Accepted -> getString(R.string.status_accepted)
            is ConsentResult.Declined -> getString(R.string.status_declined)
            is ConsentResult.NotRequired -> getString(R.string.status_not_required)
        }
        binding.statusText.text = statusText
    }
}
