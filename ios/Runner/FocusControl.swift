import Foundation
import UIKit
import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

private let APP_GROUP_ID = "group.com.geumpumgalchwi.geumpumta"
private let SELECTION_KEY = "focus_selection"

private let STUDY_ACTIVITY_NAME = DeviceActivityName("study")

@MainActor
final class FocusControl {
    static let shared = FocusControl()

    private let store = ManagedSettingsStore()
    private var selection = FamilyActivitySelection()

    func requestAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func selectApps(from vc: UIViewController) {
        let initial = FamilyActivitySelection.load(key: SELECTION_KEY)
        self.selection = initial

        let view = FamilyActivityPickerView(
            initialSelection: initial
        ) { [weak self] newSelection in
            guard let self else { return }
            self.selection = newSelection
            newSelection.save(key: SELECTION_KEY)
        }

        let host = UIHostingController(rootView: view)
        vc.present(host, animated: true)
    }

    func startFocus() {
        let savedSelection = FamilyActivitySelection.load(key: "focus_selection")

        store.shield.applications = savedSelection.applicationTokens
        store.shield.applicationCategories = .specific(savedSelection.categoryTokens)

        let center = DeviceActivityCenter()

        let now = Date()
        let cal = Calendar.current
        let startDate = cal.date(byAdding: .minute, value: 1, to: now) ?? now
        let startComp = cal.dateComponents([.hour, .minute], from: startDate)

        let endComp = DateComponents(hour: 23, minute: 59)

        let schedule = DeviceActivitySchedule(
            intervalStart: startComp,
            intervalEnd: endComp,
            repeats: true
        )

        do {
            try center.startMonitoring(DeviceActivityName("study"), during: schedule)
            print("startMonitoring ok (start=\(startComp.hour ?? -1):\(startComp.minute ?? -1))")
        } catch {
            print("startMonitoring failed: \(error)")
        }
    }


    func stopFocus() {
        let center = DeviceActivityCenter()

        center.stopMonitoring([STUDY_ACTIVITY_NAME])

        store.clearAllSettings()

        print("stopFocus done")
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

// MARK: - Selection Persistence (App Group)
extension FamilyActivitySelection {

    func save(key: String) {
        let suite = UserDefaults(suiteName: APP_GROUP_ID)!
        let data = try? JSONEncoder().encode(self)
        suite.set(data, forKey: key)
    }

    static func load(key: String) -> FamilyActivitySelection {
        let suite = UserDefaults(suiteName: APP_GROUP_ID)!
        guard
            let data = suite.data(forKey: key),
            let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return FamilyActivitySelection()
        }
        return selection
    }
}
