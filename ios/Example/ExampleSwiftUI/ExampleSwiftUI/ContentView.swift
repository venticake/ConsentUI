import SwiftUI
import ConsentUI

struct ContentView: View {
    @StateObject private var consentState = ConsentState()
    @State private var statusText = "Consent Status: Not requested"

    var body: some View {
        VStack(spacing: 20) {
            Text(statusText)
                .multilineTextAlignment(.center)
                .padding()

            Button("Request Consent") {
                consentState.show()
            }

            Button("Request If Needed (EEA Check)") {
                consentState.showIfNeeded()
            }
        }
        .padding()
        .consentAlert(isPresented: $consentState.isPresented) { result in
            updateStatus(result)
            consentState.result = result
        }
        .onReceive(consentState.$result) { result in
            if let result = result, case .notRequired(_) = result {
                updateStatus(result)
            }
        }
    }

    private func updateStatus(_ result: ConsentResult) {
        switch result {
        case .accepted(let attStatus):
            var text = "Consent: Accepted"
            if let att = attStatus {
                text += "\nATT Status: \(attStatusDescription(att))"
            }
            statusText = text
        case .declined(let attStatus):
            var text = "Consent: Declined"
            if let att = attStatus {
                text += "\nATT Status: \(attStatusDescription(att))"
            }
            statusText = text
        case .notRequired(let attStatus):
            var text = "Consent: Not Required (Not in EEA)"
            if let att = attStatus {
                text += "\nATT Status: \(attStatusDescription(att))"
            }
            statusText = text
        }
    }

    private func attStatusDescription(_ status: ATTStatus) -> String {
        switch status {
        case .authorized:
            return "Authorized"
        case .denied:
            return "Denied"
        case .restricted:
            return "Restricted"
        case .notDetermined:
            return "Not Determined"
        }
    }
}

#Preview {
    ContentView()
}
