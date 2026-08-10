import Foundation
import HealthKit

final class HealthDataService {
    private let healthStore = HKHealthStore()

    static var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    static var readTypes: Set<HKObjectType> {
        var result = Set<HKObjectType>()

        if let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            result.insert(heartRate)
        }
        if let oxygen = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) {
            result.insert(oxygen)
        }
        if let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            result.insert(sleep)
        }
        if let steps = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            result.insert(steps)
        }
        if let energy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            result.insert(energy)
        }
        if let distance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            result.insert(distance)
        }

        return result
    }

    func requestAuthorization() async throws {
        guard Self.isAvailable else {
            throw HealthDataError.unavailable
        }

        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            healthStore.requestAuthorization(toShare: [], read: Self.readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: HealthDataError.authorizationNotCompleted)
                }
            }
        }
    }

    func authorizationRequestStatus() async -> HKAuthorizationRequestStatus {
        await withCheckedContinuation { continuation in
            healthStore.getRequestStatusForAuthorization(
                toShare: [],
                read: Self.readTypes
            ) { status, _ in
                continuation.resume(returning: status)
            }
        }
    }

    func fetchMetrics(referenceDate: Date = .now) async -> HealthMetrics {
        guard Self.isAvailable else {
            return HealthMetrics(
                heartRate: nil,
                sleepHours: nil,
                oxygenSaturation: nil,
                stepCount: nil,
                activeEnergy: nil,
                walkingDistanceKilometers: nil,
                updatedAt: referenceDate
            )
        }

        let heartRate = await latestHeartRate()
        let oxygen = await latestOxygenSaturation()
        let sleep = await latestSleepDuration(referenceDate: referenceDate)
        let steps = await todayCumulativeQuantity(
            identifier: .stepCount,
            unit: .count(),
            referenceDate: referenceDate
        )
        let energy = await todayCumulativeQuantity(
            identifier: .activeEnergyBurned,
            unit: .kilocalorie(),
            referenceDate: referenceDate
        )
        let distance = await todayCumulativeQuantity(
            identifier: .distanceWalkingRunning,
            unit: .meterUnit(with: .kilo),
            referenceDate: referenceDate
        )

        return HealthMetrics(
            heartRate: heartRate,
            sleepHours: sleep,
            oxygenSaturation: oxygen,
            stepCount: steps,
            activeEnergy: energy,
            walkingDistanceKilometers: distance,
            updatedAt: referenceDate
        )
    }

    private func todayCumulativeQuantity(
        identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        referenceDate: Date
    ) async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return nil
        }
        let start = Calendar.autoupdatingCurrent.startOfDay(for: referenceDate)
        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: referenceDate,
            options: .strictStartDate
        )

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                continuation.resume(
                    returning: result?.sumQuantity()?.doubleValue(for: unit)
                )
            }
            healthStore.execute(query)
        }
    }

    private func latestHeartRate() async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return nil
        }
        let unit = HKUnit.count().unitDivided(by: .minute())
        return await latestQuantity(type: type, unit: unit)
    }

    private func latestOxygenSaturation() async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            return nil
        }
        return await latestQuantity(type: type, unit: .percent())
    }

    private func latestQuantity(type: HKQuantityType, unit: HKUnit) async -> Double? {
        await withCheckedContinuation { continuation in
            let sort = NSSortDescriptor(
                key: HKSampleSortIdentifierEndDate,
                ascending: false
            )
            let query = HKSampleQuery(
                sampleType: type,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                let value = (samples?.first as? HKQuantitySample)?
                    .quantity
                    .doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }

    private func latestSleepDuration(referenceDate: Date) async -> Double? {
        guard let type = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            return nil
        }

        let calendar = Calendar.autoupdatingCurrent
        let startOfToday = calendar.startOfDay(for: referenceDate)
        let queryStart = calendar.date(byAdding: .hour, value: -8, to: startOfToday)
            ?? referenceDate.addingTimeInterval(-32_400)
        let queryEnd = calendar.date(byAdding: .hour, value: 12, to: startOfToday)
            ?? referenceDate
        let predicate = HKQuery.predicateForSamples(
            withStart: queryStart,
            end: queryEnd,
            options: .strictStartDate
        )

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [
                    NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
                ]
            ) { _, samples, _ in
                let acceptedValues = Set([
                    HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
                    HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                    HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                    HKCategoryValueSleepAnalysis.asleepREM.rawValue
                ])

                let intervals = (samples as? [HKCategorySample] ?? [])
                    .filter { acceptedValues.contains($0.value) }
                    .map { DateInterval(start: $0.startDate, end: $0.endDate) }

                guard !intervals.isEmpty else {
                    continuation.resume(returning: nil)
                    return
                }

                let merged = Self.merge(intervals: intervals)
                let seconds = merged.reduce(0) { partial, interval in
                    partial + interval.duration
                }
                continuation.resume(returning: min(seconds / 3_600, 24))
            }
            healthStore.execute(query)
        }
    }

    private static func merge(intervals: [DateInterval]) -> [DateInterval] {
        let sorted = intervals.sorted { $0.start < $1.start }
        guard var current = sorted.first else { return [] }

        var result = [DateInterval]()
        for interval in sorted.dropFirst() {
            if interval.start <= current.end {
                current = DateInterval(
                    start: current.start,
                    end: max(current.end, interval.end)
                )
            } else {
                result.append(current)
                current = interval
            }
        }
        result.append(current)
        return result
    }
}

enum HealthDataError: LocalizedError {
    case unavailable
    case authorizationNotCompleted

    var errorDescription: String? {
        switch self {
        case .unavailable:
            "这台设备不支持 Apple 健康数据。"
        case .authorizationNotCompleted:
            "健康数据授权没有完成。"
        }
    }
}
