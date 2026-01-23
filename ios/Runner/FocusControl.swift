import Foundation
import FamilyControls
import ManagedSettings

@MainActor
class FocusControl {

    static let shared = FocusControl()

    private let store = ManagedSettingsStore()
    private var selection = FamilyActivitySelection()

    func requestAuthorization() async throws {
        try await AuthorizationCenter.shared
            .requestAuthorization(for: .individual)
    }

    func selectApps(from vc: UIViewController) {
        let picker = FamilyActivityPicker(selection: $selection)
        vc.present(picker, animated: true)
    }

    func startFocus() {
        store.shield.applications = selection.applicationTokens
    }

    func stopFocus() {
        store.shield.applications = nil
    }
}
