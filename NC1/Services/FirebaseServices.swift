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
    
    func pairUserWithPartnerId(partnerId: String) async {
        defaults.setValue(partnerId, forKey: "partnerId")
        
        do {
            try await ref.child("users").child(currentUserId).updateChildValues(["partnerId": partnerId])
            try await ref.child("users").child(partnerId).updateChildValues(["partnerId": currentUserId])
            
            let partnerPushNotifToken = await self.getPartnerPushNotifToken(partnerId: partnerId)
            let currentUserPushNotifToken = await self.getPartnerPushNotifToken(partnerId: currentUserId)
            
            try await ref.child("users").child(currentUserId).updateChildValues(["partnerPushNotifToken": partnerPushNotifToken])
            try await ref.child("users").child(partnerId).updateChildValues(["partnerPushNotifToken": currentUserPushNotifToken])
        } catch {
            print(error)
        }
    }
    
    func updateUserHeartRateAndHRV(heartRate: Int, hrv: Int) async {
        do {
            try await ref.child("users").child(currentUserId).updateChildValues(["hrv": hrv])
            try await ref.child("users").child(currentUserId).updateChildValues(["heartRate": heartRate])
        } catch {
            print(error)
        }
    }
    
    func getPartnerPushNotifToken (partnerId: String) async -> String {
        let snapshot = try? await ref.child("users/\(partnerId)/pushNotificationToken").getData()
        
        if snapshot == nil {
            return ""
        }
        
        let notifToken = snapshot?.value as! String
        
        return notifToken
    }
}
