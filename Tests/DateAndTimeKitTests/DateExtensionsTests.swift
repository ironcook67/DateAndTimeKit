//
//  DateExtensionsTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for Date extensions.
///
/// These tests verify the convenience properties added to Date for common
/// date calculations like start/end of periods and relative dates.
final class DateExtensionsTests: XCTestCase {

    /// Current date for testing (captured at test start)
    private var currentDate: Date!

    /// Date calculator for verification
    private var calculator: DateCalculator!

    override func setUp() {
        super.setUp()
        currentDate = Date.now
        calculator = DateCalculator()
    }

    override func tearDown() {
        currentDate = nil
        calculator = nil
        super.tearDown()
    }

    // MARK: - Current Period Tests

    func testStartOfCurrentHour() {
        let result = Date.startOfCurrentHour
        let expected = calculator.startOfHour(for: currentDate)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "Start of current hour should match calculator result")

        // Verify the minutes and seconds are zero
        let components = Calendar.current.dateComponents([.minute, .second], from: result)
        XCTAssertEqual(components.minute, 0, "Minutes should be 0")
        XCTAssertEqual(components.second, 0, "Seconds should be 0")
    }

    func testStartOfToday() {
        let result = Date.startOfToday
        let expected = calculator.startOfDay(for: currentDate)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "Start of today should match calculator result")

        // Verify it's actually start of day
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)
        XCTAssertEqual(components.hour, 0, "Hour should be 0")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")
    }

    func testEndOfToday() {
        let result = Date.endOfToday
        let expected = calculator.endOfDay(for: currentDate)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "End of today should match calculator result")

        // Verify it's actually end of day
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)
        XCTAssertEqual(components.hour, 23, "Hour should be 23")
        XCTAssertEqual(components.minute, 59, "Minute should be 59")
        XCTAssertEqual(components.second, 59, "Second should be 59")
    }

    // MARK: - Relative Date Tests

    func testDayEarlierSameTime() {
        let result = Date.dayEarlierSameTime
        let expected = calculator.subtract(from: currentDate, days: 1)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "Day earlier same time should match calculator result")

        // Verify it's exactly 24 hours earlier
        let hoursDifference = result.timeIntervalSince(currentDate) / 3600
        XCTAssertEqual(hoursDifference, -24, accuracy: 0.01, "Should be 24 hours earlier")
    }

    func testStartOfYesterday() {
        let result = Date.startOfYesterday
        let dayEarlier = calculator.subtract(from: currentDate, days: 1)
        let expected = calculator.startOfDay(for: dayEarlier)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "Start of yesterday should match expected calculation")

        // Verify it's actually start of day
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)
        XCTAssertEqual(components.hour, 0, "Hour should be 0")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")

        // Verify it's one day before start of today
        let startOfToday = Date.startOfToday
        let daysDifference = calculator.daysBetween(result, and: startOfToday)
        XCTAssertEqual(daysDifference, 2, "Should be 2 days inclusive between yesterday and today")
    }

    func testStartOfTomorrow() {
        let result = Date.startOfTomorrow
        let startOfToday = calculator.startOfDay(for: currentDate)
        let expected = calculator.add(to: startOfToday, days: 1)

        // Allow for small time differences due to execution time
        let timeDifference = abs(result.timeIntervalSince(expected))
        XCTAssertLessThan(timeDifference, 1.0, "Start of tomorrow should match expected calculation")

        // Verify it's actually start of day
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: result)
        XCTAssertEqual(components.hour, 0, "Hour should be 0")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")

        // Verify it's one day after start of today
        let startOfToday2 = Date.startOfToday
        let daysDifference = calculator.daysBetween(startOfToday2, and: result)
        XCTAssertEqual(daysDifference, 2, "Should be 2 days inclusive between today and tomorrow")
    }

    // MARK: - Relationship Tests

    func testDateRelationships() {
        let startOfToday = Date.startOfToday
        let endOfToday = Date.endOfToday
        let startOfYesterday = Date.startOfYesterday
        let startOfTomorrow = Date.startOfTomorrow

        // Test chronological order
        XCTAssertTrue(startOfYesterday < startOfToday, "Yesterday should be before today")
        XCTAssertTrue(startOfToday < endOfToday, "Start of today should be before end of today")
        XCTAssertTrue(endOfToday < startOfTomorrow, "End of today should be before start of tomorrow")

        // Test same day relationships
        XCTAssertTrue(calculator.areSameDay(startOfToday, endOfToday), "Start and end of today should be same day")
        XCTAssertFalse(calculator.areSameDay(startOfToday, startOfYesterday), "Today and yesterday should be different days")
        XCTAssertFalse(calculator.areSameDay(startOfToday, startOfTomorrow), "Today and tomorrow should be different days")
    }

    // MARK: - Consistency Tests

    func testConsistencyAcrossMultipleCalls() {
        // Call the properties multiple times and ensure they remain consistent
        let firstStartOfToday = Date.startOfToday
        let secondStartOfToday = Date.startOfToday

        // Should be very close (within a few milliseconds)
        let timeDifference = abs(firstStartOfToday.timeIntervalSince(secondStartOfToday))
        XCTAssertLessThan(timeDifference, 0.1, "Multiple calls should return consistent results")
    }

    func testPropertiesUseCurrentTime() {
        // Capture properties at different times to ensure they use current time
        let firstStartOfHour = Date.startOfCurrentHour

        // Wait a small amount of time
        let expectation = XCTestExpectation(description: "Wait for time to pass")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        let secondStartOfHour = Date.startOfCurrentHour

        // They should be the same since we're within the same hour
        let hourComponents1 = Calendar.current.dateComponents([.year, .month, .day, .hour], from: firstStartOfHour)
        let hourComponents2 = Calendar.current.dateComponents([.year, .month, .day, .hour], from: secondStartOfHour)

        XCTAssertEqual(hourComponents1.year, hourComponents2.year, "Year should be same")
        XCTAssertEqual(hourComponents1.month, hourComponents2.month, "Month should be same")
        XCTAssertEqual(hourComponents1.day, hourComponents2.day, "Day should be same")
        XCTAssertEqual(hourComponents1.hour, hourComponents2.hour, "Hour should be same")
    }

    // MARK: - Edge Case Tests

    func testMidnightEdgeCase() {
        // Test the properties around midnight by mocking a midnight time
        var midnightComponents = DateComponents()
        midnightComponents.year = 2024
        midnightComponents.month = 6
        midnightComponents.day = 18
        midnightComponents.hour = 0
        midnightComponents.minute = 0
        midnightComponents.second = 0

        let mockMidnight = Calendar.current.date(from: midnightComponents)!

        // Test with a known midnight time using the calculator directly
        let startOfDay = calculator.startOfDay(for: mockMidnight)
        let endOfDay = calculator.endOfDay(for: mockMidnight)
        let startOfHour = calculator.startOfHour(for: mockMidnight)

        XCTAssertEqual(startOfDay, mockMidnight, "Midnight should equal start of day")
        XCTAssertEqual(startOfHour, mockMidnight, "Midnight should equal start of hour")

        let endComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: endOfDay)
        XCTAssertEqual(endComponents.hour, 23, "End of day hour should be 23")
        XCTAssertEqual(endComponents.minute, 59, "End of day minute should be 59")
        XCTAssertEqual(endComponents.second, 59, "End of day second should be 59")
    }

    func testMonthBoundaryEdgeCase() {
        // Test around month boundaries
        var endOfMonthComponents = DateComponents()
        endOfMonthComponents.year = 2024
        endOfMonthComponents.month = 1
        endOfMonthComponents.day = 31
        endOfMonthComponents.hour = 12
        endOfMonthComponents.minute = 0

        let endOfJanuary = Calendar.current.date(from: endOfMonthComponents)!

        let nextDay = calculator.add(to: endOfJanuary, days: 1)
        let nextDayComponents = Calendar.current.dateComponents([.month, .day], from: nextDay)

        XCTAssertEqual(nextDayComponents.month, 2, "Next day should be February")
        XCTAssertEqual(nextDayComponents.day, 1, "Next day should be the 1st")
    }

    func testLeapYearEdgeCase() {
        // Test February 29 in a leap year
        var leapDayComponents = DateComponents()
        leapDayComponents.year = 2024
        leapDayComponents.month = 2
        leapDayComponents.day = 29
        leapDayComponents.hour = 12
        leapDayComponents.minute = 0

        let leapDay = Calendar.current.date(from: leapDayComponents)!

        let nextDay = calculator.add(to: leapDay, days: 1)
        let nextDayComponents = Calendar.current.dateComponents([.month, .day], from: nextDay)

        XCTAssertEqual(nextDayComponents.month, 3, "Day after Feb 29 should be March")
        XCTAssertEqual(nextDayComponents.day, 1, "Day after Feb 29 should be March 1")
    }
}
