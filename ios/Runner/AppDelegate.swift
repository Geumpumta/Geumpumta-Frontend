import UIKit
import Flutter
import Network

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let monitor = NWPathMonitor()
    private var networkChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        // 네트워크 변경 감지 관련 swift 코드
        let controller = window?.rootViewController as! FlutterViewController

        networkChannel = FlutterMethodChannel(
            name: "network_monitor",
            binaryMessenger: controller.binaryMessenger
        )

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if path.status == .satisfied {
                    let isWifi = path.usesInterfaceType(.wifi)
                    self.networkChannel?.invokeMethod(
                        "network_changed",
                        arguments: [
                            "type": "changed",
                            "isWifi": isWifi
                        ]
                    )
                } else {
                    self.networkChannel?.invokeMethod(
                        "network_changed",
                        arguments: [
                            "type": "lost",
                            "isWifi": false
                        ]
                    )
                }
            }
        }

        monitor.start(queue: DispatchQueue.global(qos: .background))



        // Focus Control 관련 Swift 코드
        let focusChannel = FlutterMethodChannel(
            name: "focus_control",
            binaryMessenger: controller.binaryMessenger
        )

        focusChannel.setMethodCallHandler { call, result in
            Task { @MainActor in
                switch call.method {

                case "requestAuthorization":
                    do {
                        try await FocusControl.shared.requestAuthorization()
                        result(true)
                    } catch {
                        result(
                            FlutterError(
                                code: "AUTH_FAILED",
                                message: "Family Controls authorization failed",
                                details: nil
                            )
                        )
                    }

                case "selectApps":
                    FocusControl.shared.selectApps(from: controller)
                    result(true)

                case "startFocus":
                    FocusControl.shared.startFocus()
                    result(true)

                case "stopFocus":
                    FocusControl.shared.stopFocus()
                    result(true)

                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
