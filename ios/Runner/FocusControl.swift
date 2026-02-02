import UIKit
import SwiftUI
import FamilyControls
import ManagedSettings

@MainActor
final class FocusControl {
    static let shared = FocusControl()
    private let store = ManagedSettingsStore()
    private var selection = FamilyActivitySelection()

    func requestAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    // SwiftUI picker를 HostingController로 감싸서 present
    func selectApps(from vc: UIViewController) {
        let view = FamilyActivityPickerView(
            initialSelection: selection
        ) { [weak self] newSelection in
            self?.selection = newSelection
        }

        let host = UIHostingController(rootView: view)
        vc.present(host, animated: true)
    }

    func startFocus() {
        store.shield.applications = selection.applicationTokens
    }

    func stopFocus() {
        store.shield.applications = nil
    }
}


/// SwiftUI 래퍼: 시스템 제공 앱 선택 UI
private struct FamilyActivityPickerView: View {

    @State private var selection: FamilyActivitySelection
    private let onDone: (FamilyActivitySelection) -> Void
    @Environment(\.dismiss) private var dismiss

    init(
        initialSelection: FamilyActivitySelection,
        onDone: @escaping (FamilyActivitySelection) -> Void
    ) {
        _selection = State(initialValue: initialSelection)
        self.onDone = onDone
    }

    var body: some View {
        NavigationView {
            FamilyActivityPicker(selection: $selection)
                .navigationTitle("차단 앱 선택")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("완료") {
                            onDone(selection)
                            dismiss()
                        }
                    }
                }
        }
    }
}
