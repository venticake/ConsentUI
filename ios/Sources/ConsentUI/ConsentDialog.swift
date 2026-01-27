import UIKit

/// UIAlertController wrapper for consent dialog
public final class ConsentDialog {

    /// Show consent dialog
    /// - Parameters:
    ///   - viewController: The view controller to present from
    ///   - completion: Callback with user's choice (true = accepted, false = declined)
    public static func show(
        from viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(
            title: ConsentStrings.title,
            message: ConsentStrings.message,
            preferredStyle: .alert
        )

        // "Allow" button - default style for natural selection
        let allowAction = UIAlertAction(
            title: ConsentStrings.allow,
            style: .default
        ) { _ in
            completion(true)
        }

        // "Decline" button - cancel style
        let declineAction = UIAlertAction(
            title: ConsentStrings.decline,
            style: .cancel
        ) { _ in
            completion(false)
        }

        alert.addAction(declineAction)
        alert.addAction(allowAction)

        // Make "Allow" the preferred action (highlighted)
        alert.preferredAction = allowAction

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}
