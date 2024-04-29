//
//  CoupleView.swift
//  UwU
//
//  Created by Gracella Noveliora on 29/04/24.
//

import SwiftUI
import HealthKit

enum StressLevel {
    case low
    case medium
    case high
}

struct CoupleScreenView: View {
    var low = [Color("DarkGreen"), Color("LightGreen")]
    var medium = [Color("DarkYellow"), Color("LightYellow")]
    var high = [Color("DarkRed"), Color("LightRed")]
    
    var timer = Timer()
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
        
    @State private var value = 0
    @State private var userStressLevel: StressLevel = .low
    @State private var partnerStressLevel: StressLevel = .low
    
    @EnvironmentObject var healthManager: HealthManager
    
    func detectUserStressLevel() {
        withAnimation(.easeIn) {
            userStressLevel = .high
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(.loveBird).resizable().frame(width: 175, height: 70)
                    
                    Spacer()
                    
                    ZStack {
                        StressLevelBackground(userStressLevel: $userStressLevel)
                        
                        Image(.dog).resizable().frame(width: 106.33, height: 80)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 34))
                            .foregroundColor(Color.red)
                            .offset(x:-50, y:65)
                    }.offset(CGSize(width: -75, height: 0))
                    
                    ZStack {
                        StressLevelBackground(userStressLevel: $partnerStressLevel)
                        
                        Image(.cat).resizable().frame(width: 64.35, height: 80)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 34))
                            .foregroundColor(Color.red)
                            .offset(x:50, y:65)
                    }.offset(CGSize(width: 75.0, height: 0))
                    
                    Spacer()
                    
                    
                    Button {
                        detectUserStressLevel()
                    } label: {
                        Text("Change stress level \(healthManager.hrv)")
                    }
                    
                    
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
                Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                    Task {
                        await healthManager.fetchHeartRate()
                        
                        DispatchQueue.main.async {
                            userStressLevel = healthManager.determineStressLevel(hrv: healthManager.hrv ?? 0)
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
