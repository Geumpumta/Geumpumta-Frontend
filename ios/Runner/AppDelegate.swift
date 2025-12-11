import UIKit
import Flutter
import Network

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    let monitor = NWPathMonitor()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        // 1) Flutter plugin 등록 (shared_preferences 포함)
        GeneratedPluginRegistrant.register(with: self)

        // 2) Flutter 엔진 가져오기
        let controller = window?.rootViewController as! FlutterViewController

        // 3) MethodChannel 생성
        let channel = FlutterMethodChannel(
            name: "network_monitor",
            binaryMessenger: controller.binaryMessenger
        )

        // 4) 네트워크 모니터링 핸들러
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    let isWifi = path.usesInterfaceType(.wifi)
                    channel.invokeMethod(
                        "network_changed",
                        arguments: [
                            "type": "changed",
                            "isWifi": isWifi
                        ]
                    )
                } else {
                    channel.invokeMethod(
                        "network_changed",
                        arguments: [
                            "type": "lost",
                            "isWifi": false
                        ]
                    )
                }
            }
        }

        // 5) 모니터 시작
        monitor.start(queue: DispatchQueue.global(qos: .background))

        // 6) Flutter 기본 동작 이어가기
        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
