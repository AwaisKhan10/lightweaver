import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // If you see NSRangeException (subdataWithRange exceeds data length) on launch,
    // uncomment the next 2 lines once to clear corrupted SharedPreferences, then comment back.
    // if let name = Bundle.main.bundleIdentifier {
    //   UserDefaults.standard.removePersistentDomain(forName: name)
    // }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
