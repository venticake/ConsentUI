import SwiftUI

/// SwiftUI View for consent dialog
@available(iOS 13.0, *)
public struct ConsentView: View {
    @Binding var isPresented: Bool
    let onResult: (ConsentResult) -> Void

    public init(
        isPresented: Binding<Bool>,
        onResult: @escaping (ConsentResult) -> Void
    ) {
        self._isPresented = isPresented
        self.onResult = onResult
    }

    public var body: some View {
        if #available(iOS 15.0, *) {
            EmptyView()
                .alert(ConsentStrings.title, isPresented: $isPresented) {
                    Button(ConsentStrings.allow) {
                        ATTManager.shared.requestAuthorization { attStatus in
                            onResult(.accepted(attStatus: attStatus))
                        }
                    }
                    .keyboardShortcut(.defaultAction)

                    Button(ConsentStrings.decline, role: .cancel) {
                        onResult(.declined)
                    }
                } message: {
                    Text(ConsentStrings.message)
                }
        } else {
            EmptyView()
                .alert(isPresented: $isPresented) {
                    Alert(
                        title: Text(ConsentStrings.title),
                        message: Text(ConsentStrings.message),
                        primaryButton: .default(Text(ConsentStrings.allow)) {
                            ATTManager.shared.requestAuthorization { attStatus in
                                onResult(.accepted(attStatus: attStatus))
                            }
                        },
                        secondaryButton: .cancel(Text(ConsentStrings.decline)) {
                            onResult(.declined)
                        }
                    )
                }
        }
    }
}

/// ViewModifier for consent alert
@available(iOS 13.0, *)
public struct ConsentAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onResult: (ConsentResult) -> Void

    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .alert(ConsentStrings.title, isPresented: $isPresented) {
                    Button(ConsentStrings.allow) {
                        ATTManager.shared.requestAuthorization { attStatus in
                            onResult(.accepted(attStatus: attStatus))
                        }
                    }
                    .keyboardShortcut(.defaultAction)

                    Button(ConsentStrings.decline, role: .cancel) {
                        onResult(.declined)
                    }
                } message: {
                    Text(ConsentStrings.message)
                }
        } else {
            content
                .alert(isPresented: $isPresented) {
                    Alert(
                        title: Text(ConsentStrings.title),
                        message: Text(ConsentStrings.message),
                        primaryButton: .default(Text(ConsentStrings.allow)) {
                            ATTManager.shared.requestAuthorization { attStatus in
                                onResult(.accepted(attStatus: attStatus))
                            }
                        },
                        secondaryButton: .cancel(Text(ConsentStrings.decline)) {
                            onResult(.declined)
                        }
                    )
                }
        }
    }
}

@available(iOS 13.0, *)
public extension View {
    /// Add a consent alert to this view
    /// - Parameters:
    ///   - isPresented: Binding to control alert presentation
    ///   - onResult: Callback with the consent result
    /// - Returns: Modified view with consent alert
    func consentAlert(
        isPresented: Binding<Bool>,
        onResult: @escaping (ConsentResult) -> Void
    ) -> some View {
        self.modifier(
            ConsentAlertModifier(
                isPresented: isPresented,
                onResult: onResult
            )
        )
    }
}

/// Observable state for consent in SwiftUI
@available(iOS 13.0, *)
public final class ConsentState: ObservableObject {
    @Published public var isPresented: Bool = false
    @Published public var result: ConsentResult?

    public init() {}

    /// Show consent dialog if needed based on region
    public func showIfNeeded() {
        if RegionChecker.shared.isConsentRequired() {
            isPresented = true
        } else {
            result = .notRequired
        }
    }

    /// Show consent dialog
    public func show() {
        isPresented = true
    }
}
