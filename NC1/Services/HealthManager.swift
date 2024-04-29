//
//  HealthManager.swift
//  HeartRate
//
//  Created by Gracella Noveliora on 29/04/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var hrv: Int? = 0
    @Published var heartRate: Int = 0
    @Published var userStressLevel: StressLevel = .low
    
    init() {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: [
                    HKQuantityType(.heartRateVariabilitySDNN),
                    HKQuantityType(.heartRate),
                ])
            } catch {
                print("error fetching health data")
            }
        }
    }
    
    func determineStressLevel (hrv: Int) -> StressLevel {
        if hrv >= 40 {
            return .low
        }
        
        if hrv >= 20 && hrv < 40 {
            return .medium
        }
        
        return .high
    }
    
    func fetchHeartRateVariability() async {
        
        let typeHeart = HKQuantityType(.heartRateVariabilitySDNN)
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.quantitySample(type: typeHeart)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1)
        
        do {
            let results = try await descriptor.result(for: healthStore)
            
            DispatchQueue.main.async {
                if !results.isEmpty {
                    self.hrv = Int(results.first!.quantity.doubleValue(for: .secondUnit(with: .milli)))
                }
            }
        } catch {
            print("error fetching HRV", error)
        }
    }
    
    func fetchHeartRate() async {
        let typeHeart = HKQuantityType(.heartRate)
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.quantitySample(type: typeHeart)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 10)
        
        do {
            let results = try await descriptor.result(for: healthStore)
            
            DispatchQueue.main.async {
                if !results.isEmpty {
//                    print(results)
                    self.heartRate = Int(results.first!.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
                }
            }
        } catch {
            print("error fetching Heart Rate", error)
        }
    }
}
