import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configure Firebase first
    FirebaseApp.configure()

    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Configure notifications
    configureNotifications(application)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureNotifications(_ application: UIApplication) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self

      // Request notification permissions
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
          print("AppDelegate: Erro ao solicitar permissões de notificação: \(error)")
        } else {
          print("AppDelegate: Permissões de notificação: \(granted ? "concedidas" : "negadas")")
        }

        DispatchQueue.main.async {
          if granted {
            application.registerForRemoteNotifications()
            print("AppDelegate: Registrando para notificações remotas...")
          }
        }
      }
    } else {
      // iOS 9 and below
      let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
    }
  }

  // Handle successful registration for remote notifications
  override func application(_ application: UIApplication,
                           didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    // Set APNS token for Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken

    // Call super to ensure Flutter plugins receive the token
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // Handle failed registration for remote notifications
  override func application(_ application: UIApplication,
                           didFailToRegisterForRemoteNotificationsWithError error: Error) {

    // Log additional error details
    if let nsError = error as NSError? {
      print("AppDelegate: Código de erro: \(nsError.code)")
      print("AppDelegate: Domain: \(nsError.domain)")
      print("AppDelegate: User info: \(nsError.userInfo)")
    }

    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {

  // Handle notification when app is in foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("📬 AppDelegate: Notificação recebida em foreground")

    // Show notification even when app is in foreground
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  // Handle notification tap
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      didReceive response: UNNotificationResponse,
                                      withCompletionHandler completionHandler: @escaping () -> Void) {

    let userInfo = response.notification.request.content.userInfo

    // TODO: Handle navigation based on notification data
    completionHandler()
  }
}
