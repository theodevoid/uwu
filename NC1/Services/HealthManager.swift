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
                    ///TODO: DEV PURPOSES ONLY, REMOVE - 20
                    self.hrv = Int(results.first!.quantity.doubleValue(for: .secondUnit(with: .milli))) - 20
                }
            }
        } catch {
            print("error fetching HRV", error)
        }
        
        
        
        
//        let startDate = Date() - 1 * 1 * 5 * 60
//        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
//        let squery = HKStatisticsQuery(quantityType: typeHeart!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
//            DispatchQueue.main.async(execute: {() -> Void in
//                let quantity: HKQuantity? = result?.averageQuantity()
//                let beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
//                
//                self.bpm = beats
//                print("got: \(beats)")
//            })
//        })
//        healthStore.execute(squery)
    }
    
    func fetchHeartRate() async {
        let typeHeart = HKQuantityType(.heartRate)
        let descriptor = HKSampleQueryDescriptor(
            predicates:[.quantitySample(type: typeHeart)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1)
        
        do {
            let results = try await descriptor.result(for: healthStore)
            
            DispatchQueue.main.async {
                if !results.isEmpty {
                    ///TODO: DEV PURPOSES ONLY, REMOVE - 20
                    self.heartRate = Int(results.first!.quantity.doubleValue(for: .count().unitDivided(by: .minute()))) - 20
                }
            }
        } catch {
            print("error fetching HRV", error)
        }
        
        
        
        
//        let startDate = Date() - 1 * 1 * 5 * 60
//        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
//        let squery = HKStatisticsQuery(quantityType: typeHeart!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
//            DispatchQueue.main.async(execute: {() -> Void in
//                let quantity: HKQuantity? = result?.averageQuantity()
//                let beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
//
//                self.bpm = beats
//                print("got: \(beats)")
//            })
//        })
//        healthStore.execute(squery)
    }
}
