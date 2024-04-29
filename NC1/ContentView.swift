//
//  ContentView.swift
//  NC1
//
//  Created by Theodore Mangowal on 26/04/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseInternal
import FirebaseMessaging

struct ContentView: View {
//    var ref: DatabaseReference!
    var defaults = UserDefaults.standard
    var ref = Database.database(url: "https://ada-nc1-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    func testDb () {
//        let uuid = UUID().uuidString
        self.ref.child("users").child(defaults.string(forKey: "userId")!).setValue(["username": "test"])
    }
    
    func getFCMTokenAndSendToDatabase () {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                self.ref.child("users").child(defaults.string(forKey: "userId")!).updateChildValues(["pushNotificationToken": token])
            }
        }
    }
    
    
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            Button {
//                getFCMTokenAndSendToDatabase()
//            } label: {
//                Text("Press me")
//            }
            QRScreenView()
        }
//        .padding()
        .onAppear {
            getFCMTokenAndSendToDatabase()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
