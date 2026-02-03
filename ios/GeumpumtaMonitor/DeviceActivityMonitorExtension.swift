import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

private let APP_GROUP_ID = "group.com.geumpumgalchwi.geumpumta"
private let SELECTION_KEY = "focus_selection"

final class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let store = ManagedSettingsStore()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        print("intervalDidStart called:", activity)

        let suite = UserDefaults(suiteName: APP_GROUP_ID)!
        let selection: FamilyActivitySelection = {
            guard
                let data = suite.data(forKey: SELECTION_KEY),
                let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            else {
                return FamilyActivitySelection()
            }
            return decoded
        }()
        print("tokens:", selection.applicationTokens.count)

        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = .specific(selection.categoryTokens)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        store.clearAllSettings()
    }
}
