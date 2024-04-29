//
//  FirebaseServices.swift
//  NC1
//
//  Created by Theodore Mangowal on 26/04/24.
//

import Foundation
import FirebaseDatabase

class FirebaseServices {
    var defaults = UserDefaults.standard
    var ref = Database.database(url: "https://ada-nc1-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    var currentUserId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    func testDb () {
//        let uuid = UUID().uuidString
        self.ref.child("users").child(defaults.string(forKey: "userId")!).setValue(["username": "test"])
    }
    
    func pairUserWithPartnerId(partnerId: String) {
        ref.child("users").child(currentUserId).updateChildValues(["partnerId": partnerId])
        
        ref.child("users").child(partnerId).updateChildValues(["partnerId": currentUserId])
    }
    
    func getPartnerPushNotifToken (partnerId: String) async -> String {
        var snapshot = try? await ref.child("users/\(partnerId)/pushNotificationToken").getData()
        
        var notifToken = snapshot?.value as! String
        
        return notifToken
    }
}
