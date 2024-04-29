//
//  NC1App.swift
//  NC1
//
//  Created by Theodore Mangowal on 26/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import FirebaseDatabase

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var defaults = UserDefaults.standard
    var ref:DatabaseReference? = nil
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        ref = Database.database(url: "https://ada-nc1-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // set user's random UUID to pair with partner
        if defaults.object(forKey: "userId") == nil {
            print("MASUK SINIIIII")
            defaults.setValue(UUID().uuidString, forKey: "userId")
        }
        
        // request notification permissions
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        // init firebase messaging
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN", deviceToken)
        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                self.ref?.child("users").child(self.defaults.string(forKey: "userId")!).updateChildValues(["pushNotificationToken": token])
            }
        }
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      
      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print full message.
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
}

@main
struct NC1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var healthManager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .preferredColorScheme(.light)
        }
    }
}
