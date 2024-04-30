//
//  CoupleView.swift
//  UwU
//
//  Created by Gracella Noveliora on 29/04/24.
//

import SwiftUI
import HealthKit
import FirebaseDatabase

enum StressLevel {
    case low
    case medium
    case high
}

struct CoupleScreenView: View {
    var defaults = UserDefaults.standard
    
    var ref = Database.database(url: "https://ada-nc1-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    var low = [Color("DarkGreen"), Color("LightGreen")]
    var medium = [Color("DarkYellow"), Color("LightYellow")]
    var high = [Color("DarkRed"), Color("LightRed")]
    
    var timer = Timer()
    
    private var healthStore = HKHealthStore()
    private var firebaseService = FirebaseServices()
    let heartRateQuantity = HKUnit(from: "count/min")
        
    @State private var value = 0
    @State private var userStressLevel: StressLevel = .low
    @State private var partnerStressLevel: StressLevel = .low
    
    @State private var partnerHeartRate = 0
    @State private var partnerHRV = 0
    
    @EnvironmentObject var healthManager: HealthManager
    
    @State private var userAnimateGradient = false
    @State private var partnerAnimateGradient = false
    
    func detectUserStressLevel() {
        withAnimation(.easeIn) {
            userStressLevel = .high
        }
    }
    
    func listenPartnerHeartRateAndHRV() {
        let partnerId = defaults.string(forKey: "partnerId")
        let userId = defaults.string(forKey: "userId")
        
        if partnerId != nil {
            ref.child("users").child(partnerId!).child("heartRate").observe(DataEventType.value, with: { snapshot in
                print("LISTEN PARTNER HR", snapshot.value as Any)
                partnerHeartRate = Int(snapshot.value as? Double ?? 0)
            })
            
            ref.child("users").child(partnerId!).child("hrv").observe(DataEventType.value, with: { snapshot in
                print("LISTEN PARTNER HRV", snapshot.value as Any)
                partnerHRV = Int(snapshot.value as? Double ?? 0)
                
                withAnimation(.easeIn) {
                    partnerStressLevel = healthManager.determineStressLevel(hrv: Int(snapshot.value as? Double ?? 0))
                }
            })
        }
        
        if userId != nil {
            ref.child("users").child(userId!).child("hrv").observe(DataEventType.value, with: { snapshot in
                print("LISTEN USER HRV", snapshot.value as Any)
                partnerHRV = Int(snapshot.value as? Double ?? 0)
                
                withAnimation(.easeIn) {
                    userStressLevel = healthManager.determineStressLevel(hrv: Int(snapshot.value as? Double ?? 0))
                }
            })
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(.loveBird).resizable().frame(width: 175, height: 70)
                    
                    Spacer()
                    
                    ZStack {
                        StressLevelBackground(userStressLevel: $userStressLevel, animateGradient: $userAnimateGradient)
                            .onAppear {
                                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                    userAnimateGradient.toggle()
                                }
                            }
                            .onChange(of: userStressLevel, {
                                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                    userAnimateGradient.toggle()
                                }
                            })
                        
                        Image(.dog).resizable().frame(width: 106.33, height: 80)
                        
                        HeartBeat(bpm: Double(healthManager.heartRate))
                            .offset(x:-50, y:65)
                        
                    }.offset(CGSize(width: -75, height: 0))
                    
                    if defaults.string(forKey: "partnerId") != nil {
                        ZStack {
                            StressLevelBackground(userStressLevel: $partnerStressLevel, animateGradient: $partnerAnimateGradient)
                                .onAppear {
                                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                        partnerAnimateGradient.toggle()
                                    }
                                }
                                .onChange(of: partnerStressLevel, {
                                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                        partnerAnimateGradient.toggle()
                                    }
                                })
                            
                            Image(.cat).resizable().frame(width: 64.35, height: 80)
                            
                            HeartBeat(bpm: Double(partnerHeartRate))
                                .offset(x:50, y:65)
                            
                        }.offset(CGSize(width: 75.0, height: 0))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: QRScreenView(), label: {
                        Image(systemName: "person.badge.plus").frame(width: 70, height: 30)
                            .foregroundColor(.white)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.pastelPurple)
                                    .shadow(radius: 5)
                            }
                    })
                    
                }.frame(maxWidth: .infinity, maxHeight: 500)
                    .offset(CGSize(width: 0, height: -75))
                
                WaveAnimation()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(colors: [.purpleBg, .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
            .onAppear {
                listenPartnerHeartRateAndHRV()
                
                Task {
                    await healthManager.fetchHeartRateVariability()
                    await healthManager.fetchHeartRate()
                    await firebaseService.updateUserHeartRateAndHRV(heartRate: healthManager.heartRate, hrv: healthManager.hrv ?? 0)
                    
                    DispatchQueue.main.async {
                        withAnimation(.easeIn) {
                            userStressLevel = healthManager.determineStressLevel(hrv: healthManager.hrv ?? 0)
                        }
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                    Task {
                        await healthManager.fetchHeartRateVariability()
                        await healthManager.fetchHeartRate()
                        await firebaseService.updateUserHeartRateAndHRV(heartRate: healthManager.heartRate, hrv: healthManager.hrv ?? 0)
                        
                        DispatchQueue.main.async {
                            withAnimation(.easeIn) {
                                userStressLevel = healthManager.determineStressLevel(hrv: healthManager.hrv ?? 0)
                            }
                        }
                    }
                })
            }
        }
    }
}

#Preview {
    CoupleScreenView()
}
