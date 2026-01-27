import UIKit
import ConsentUI

class ViewController: UIViewController {

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Consent Status: Not requested"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let requestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Request Consent", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let requestIfNeededButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Request If Needed (EEA Check)", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(statusLabel)
        view.addSubview(requestButton)
        view.addSubview(requestIfNeededButton)

        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),

            requestIfNeededButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestIfNeededButton.topAnchor.constraint(equalTo: requestButton.bottomAnchor, constant: 20),
        ])

        requestButton.addTarget(self, action: #selector(requestConsentTapped), for: .touchUpInside)
        requestIfNeededButton.addTarget(self, action: #selector(requestConsentIfNeededTapped), for: .touchUpInside)
    }

    @objc private func requestConsentTapped() {
        ConsentManager.shared.requestConsent(from: self) { [weak self] result in
            self?.updateStatus(result)
        }
    }

    @objc private func requestConsentIfNeededTapped() {
        ConsentManager.shared.requestConsentIfNeeded(from: self) { [weak self] result in
            self?.updateStatus(result)
        }
    }

    private func updateStatus(_ result: ConsentResult) {
        switch result {
        case .accepted(let attStatus):
            var statusText = "Consent: Accepted"
            if let att = attStatus {
                statusText += "\nATT Status: \(attStatusDescription(att))"
            }
            statusLabel.text = statusText
        case .declined:
            statusLabel.text = "Consent: Declined"
        case .notRequired:
            statusLabel.text = "Consent: Not Required (Not in EEA)"
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
