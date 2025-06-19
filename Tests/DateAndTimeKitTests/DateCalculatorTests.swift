//
//  DateCalculatorTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for DateCalculator functionality.
///
/// These tests verify date arithmetic, period boundaries, and date comparison methods
/// using both fixed dates and edge cases to ensure reliability across different scenarios.
final class DateCalculatorTests: XCTestCase {

    /// Test calculator instance using Gregorian calendar
    private var calculator: DateCalculator!

    /// Fixed test date: January 15, 2024 at 2:30:45 PM UTC
    private var testDate: Date!

    override func setUp() {
        super.setUp()
        calculator = DateCalculator(calendar: Calendar(identifier: .gregorian))

        // Create a fixed test date for consistent testing
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        components.hour = 14
        components.minute = 30
        components.second = 45
        components.timeZone = TimeZone(abbreviation: "UTC")

        testDate = Calendar(identifier: .gregorian).date(from: components)!
    }

    override func tearDown() {
        calculator = nil
        testDate = nil
        super.tearDown()
    }

    // MARK: - Date Arithmetic Tests

    func testAddDays() {
        let result = calculator.add(to: testDate, days: 5)
        let expected = Calendar(identifier: .gregorian).date(byAdding: .day, value: 5, to: testDate)!

        XCTAssertEqual(result, expected, "Adding 5 days should return January 20, 2024")
    }

    func testAddNegativeDays() {
        let result = calculator.add(to: testDate, days: -3)
        let expected = Calendar(identifier: .gregorian).date(byAdding: .day, value: -3, to: testDate)!

        XCTAssertEqual(result, expected, "Adding -3 days should return January 12, 2024")
    }

    func testAddHours() {
        let result = calculator.add(to: testDate, hours: 6)
        let expected = Calendar(identifier: .gregorian).date(byAdding: .hour, value: 6, to: testDate)!

        XCTAssertEqual(result, expected, "Adding 6 hours should return 8:30:45 PM")
    }

    func testAddMinutesAndSeconds() {
        let result = calculator.add(to: testDate, minutes: 15, seconds: 30)

        var components = DateComponents()
        components.minute = 15
        components.second = 30
        let expected = Calendar(identifier: .gregorian).date(byAdding: components, to: testDate)!

        XCTAssertEqual(result, expected, "Adding 15 minutes and 30 seconds should work correctly")
    }

    func testAddMultipleComponents() {
        let result = calculator.add(to: testDate, days: 1, hours: 2, minutes: 30, seconds: 15)

        var components = DateComponents()
        components.day = 1
        components.hour = 2
        components.minute = 30
        components.second = 15
        let expected = Calendar(identifier: .gregorian).date(byAdding: components, to: testDate)!

        XCTAssertEqual(result, expected, "Adding multiple time components should work correctly")
    }

    func testSubtractDays() {
        let result = calculator.subtract(from: testDate, days: 10)
        let expected = calculator.add(to: testDate, days: -10)

        XCTAssertEqual(result, expected, "Subtracting days should be equivalent to adding negative days")
    }

    func testSubtractMultipleComponents() {
        let result = calculator.subtract(from: testDate, days: 2, hours: 3, minutes: 15, seconds: 45)
        let expected = calculator.add(to: testDate, days: -2, hours: -3, minutes: -15, seconds: -45)

        XCTAssertEqual(result, expected, "Subtracting multiple components should work correctly")
    }

    // MARK: - Period Boundary Tests

    func testStartOfDay() {
        let result = calculator.startOfDay(for: testDate)

        let calendar = Calendar(identifier: .gregorian)
        let expected = calendar.startOfDay(for: testDate)

        XCTAssertEqual(result, expected, "Start of day should return midnight")

        // Verify the time components are set to zero
        let components = calendar.dateComponents([.hour, .minute, .second], from: result)
        XCTAssertEqual(components.hour, 0, "Hour should be 0")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")
    }

    func testEndOfDay() {
        let result = calculator.endOfDay(for: testDate)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour, .minute, .second], from: result)

        XCTAssertEqual(components.hour, 23, "Hour should be 23")
        XCTAssertEqual(components.minute, 59, "Minute should be 59")
        XCTAssertEqual(components.second, 59, "Second should be 59")
    }

    func testStartOfHour() {
        let result = calculator.startOfHour(for: testDate)

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)

        XCTAssertEqual(components.year, 2024, "Year should be preserved")
        XCTAssertEqual(components.month, 1, "Month should be preserved")
        XCTAssertEqual(components.day, 15, "Day should be preserved")
        XCTAssertEqual(components.hour, 14, "Hour should be preserved")
        XCTAssertEqual(components.minute, 0, "Minute should be 0")
        XCTAssertEqual(components.second, 0, "Second should be 0")
    }

    // MARK: - Date Comparison Tests

    func testDaysBetweenSameDay() {
        let result = calculator.daysBetween(testDate, and: testDate)
        XCTAssertEqual(result, 1, "Days between same date should be 1 (inclusive)")
    }

    func testDaysBetweenConsecutiveDays() {
        let nextDay = calculator.add(to: testDate, days: 1)
        let result = calculator.daysBetween(testDate, and: nextDay)
        XCTAssertEqual(result, 2, "Days between consecutive days should be 2 (inclusive)")
    }

    func testDaysBetweenWithGap() {
        let futureDate = calculator.add(to: testDate, days: 4)
        let result = calculator.daysBetween(testDate, and: futureDate)
        XCTAssertEqual(result, 5, "Days between dates 4 days apart should be 5 (inclusive)")
    }

    func testDaysBetweenReverseOrder() {
        let pastDate = calculator.subtract(from: testDate, days: 3)
        let result = calculator.daysBetween(testDate, and: pastDate)
        XCTAssertEqual(result, 4, "Days between should be absolute value plus 1")
    }

    func testAreSameDay() {
        let sameDay = calculator.add(to: testDate, hours: 5)
        XCTAssertTrue(calculator.areSameDay(testDate, sameDay), "Dates on same calendar day should return true")

        let differentDay = calculator.add(to: testDate, days: 1)
        XCTAssertFalse(calculator.areSameDay(testDate, differentDay), "Dates on different days should return false")
    }

    func testTimeInterval() {
        let futureDate = calculator.add(to: testDate, hours: 2)
        let result = calculator.timeInterval(from: testDate, to: futureDate)

        let expectedInterval: TimeInterval = 2 * 60 * 60 // 2 hours in seconds
        XCTAssertEqual(result, expectedInterval, accuracy: 1.0, "Time interval should be 2 hours")
    }

    func testTimeIntervalNegative() {
        let pastDate = calculator.subtract(from: testDate, hours: 3)
        let result = calculator.timeInterval(from: testDate, to: pastDate)

        let expectedInterval: TimeInterval = -3 * 60 * 60 // -3 hours in seconds
        XCTAssertEqual(result, expectedInterval, accuracy: 1.0, "Time interval should be negative for past dates")
    }

    // MARK: - Edge Case Tests

    func testLeapYearHandling() {
        // February 28, 2024 (leap year)
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 28
        components.timeZone = TimeZone(abbreviation: "UTC")

        let feb28 = Calendar(identifier: .gregorian).date(from: components)!
        let nextDay = calculator.add(to: feb28, days: 1)

        let resultComponents = Calendar(identifier: .gregorian).dateComponents([.month, .day], from: nextDay)
        XCTAssertEqual(resultComponents.month, 2, "Should still be February")
        XCTAssertEqual(resultComponents.day, 29, "Should be February 29 in leap year")
    }

    func testMonthBoundary() {
        // January 31, 2024
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 31
        components.timeZone = TimeZone(abbreviation: "UTC")

        let jan31 = Calendar(identifier: .gregorian).date(from: components)!
        let nextDay = calculator.add(to: jan31, days: 1)

        let resultComponents = Calendar(identifier: .gregorian).dateComponents([.month, .day], from: nextDay)
        XCTAssertEqual(resultComponents.month, 2, "Should be February")
        XCTAssertEqual(resultComponents.day, 1, "Should be February 1")
    }

    func testYearBoundary() {
        // December 31, 2023
        var components = DateComponents()
        components.year = 2023
        components.month = 12
        components.day = 31
        components.timeZone = TimeZone(abbreviation: "UTC")

        let dec31 = Calendar(identifier: .gregorian).date(from: components)!
        let nextDay = calculator.add(to: dec31, days: 1)

        let resultComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: nextDay)
        XCTAssertEqual(resultComponents.year, 2024, "Should be 2024")
        XCTAssertEqual(resultComponents.month, 1, "Should be January")
        XCTAssertEqual(resultComponents.day, 1, "Should be January 1")
    }
}
