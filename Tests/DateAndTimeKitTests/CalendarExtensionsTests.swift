//
//  CalendarExtensionsTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for Calendar extensions.
///
/// These tests verify the convenience properties and methods added to Calendar
/// for common calendar operations and date range calculations.
final class CalendarExtensionsTests: XCTestCase {

    /// Test date: March 15, 2024 (a leap year)
    private var testDate: Date!

    override func setUp() {
        super.setUp()

        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 14
        components.minute = 30
        components.second = 0

        testDate = Calendar.gregorian.date(from: components)!
    }

    override func tearDown() {
        testDate = nil
        super.tearDown()
    }

    // MARK: - Calendar Convenience Properties Tests

    func testCalendarConvenienceProperties() {
        XCTAssertEqual(Calendar.gregorian.identifier, .gregorian, "Gregorian calendar should have correct identifier")
        XCTAssertEqual(Calendar.iso8601.identifier, .iso8601, "ISO 8601 calendar should have correct identifier")
        XCTAssertEqual(Calendar.buddhist.identifier, .buddhist, "Buddhist calendar should have correct identifier")
        XCTAssertEqual(Calendar.hebrew.identifier, .hebrew, "Hebrew calendar should have correct identifier")
        XCTAssertEqual(Calendar.islamic.identifier, .islamic, "Islamic calendar should have correct identifier")
    }

    func testCalendarConsistency() {
        let gregorian1 = Calendar.gregorian
        let gregorian2 = Calendar.gregorian

        XCTAssertEqual(gregorian1.identifier, gregorian2.identifier, "Multiple calls should return same calendar type")
    }

    // MARK: - Days in Month Tests

    func testDaysInMonthRegular() {
        let calendar = Calendar.gregorian

        XCTAssertEqual(calendar.daysInMonth(1, year: 2024), 31, "January should have 31 days")
        XCTAssertEqual(calendar.daysInMonth(4, year: 2024), 30, "April should have 30 days")
        XCTAssertEqual(calendar.daysInMonth(12, year: 2024), 31, "December should have 31 days")
    }

    func testDaysInMonthLeapYear() {
        let calendar = Calendar.gregorian

        XCTAssertEqual(calendar.daysInMonth(2, year: 2024), 29, "February 2024 should have 29 days (leap year)")
        XCTAssertEqual(calendar.daysInMonth(2, year: 2023), 28, "February 2023 should have 28 days (not leap year)")
        XCTAssertEqual(calendar.daysInMonth(2, year: 2000), 29, "February 2000 should have 29 days (leap year)")
        XCTAssertEqual(calendar.daysInMonth(2, year: 1900), 28, "February 1900 should have 28 days (not leap year)")
    }

    func testDaysInMonthInvalidMonth() {
        let calendar = Calendar.gregorian

        XCTAssertNil(calendar.daysInMonth(0, year: 2024), "Month 0 should return nil")
        XCTAssertNil(calendar.daysInMonth(13, year: 2024), "Month 13 should return nil")
        XCTAssertNil(calendar.daysInMonth(-1, year: 2024), "Negative month should return nil")
    }

    // MARK: - Leap Year Tests

    func testIsLeapYear() {
        let calendar = Calendar.gregorian

        XCTAssertTrue(calendar.isLeapYear(2024), "2024 should be a leap year")
        XCTAssertFalse(calendar.isLeapYear(2023), "2023 should not be a leap year")
        XCTAssertTrue(calendar.isLeapYear(2000), "2000 should be a leap year")
        XCTAssertFalse(calendar.isLeapYear(1900), "1900 should not be a leap year")
        XCTAssertTrue(calendar.isLeapYear(2400), "2400 should be a leap year")
    }

    func testLeapYearEdgeCases() {
        let calendar = Calendar.gregorian

        // Century years divisible by 400 are leap years
        XCTAssertTrue(calendar.isLeapYear(1600), "1600 should be a leap year")
        XCTAssertTrue(calendar.isLeapYear(2000), "2000 should be a leap year")

        // Century years not divisible by 400 are not leap years
        XCTAssertFalse(calendar.isLeapYear(1700), "1700 should not be a leap year")
        XCTAssertFalse(calendar.isLeapYear(1800), "1800 should not be a leap year")
        XCTAssertFalse(calendar.isLeapYear(1900), "1900 should not be a leap year")
    }

    // MARK: - Week Calculation Tests

    func testStartOfWeek() {
        let calendar = Calendar.gregorian

        // March 15, 2024 is a Friday
        let startOfWeek = calendar.startOfWeek(for: testDate)
        XCTAssertNotNil(startOfWeek, "Start of week should not be nil")

        if let startOfWeek = startOfWeek {
            let components = calendar.dateComponents([.weekday], from: startOfWeek)
            XCTAssertEqual(components.weekday, calendar.firstWeekday, "Start of week should match calendar's first weekday")
        }
    }

    func testEndOfWeek() {
        let calendar = Calendar.gregorian

        let endOfWeek = calendar.endOfWeek(for: testDate)
        XCTAssertNotNil(endOfWeek, "End of week should not be nil")

        if let startOfWeek = calendar.startOfWeek(for: testDate),
           let endOfWeek = endOfWeek {
            XCTAssertTrue(endOfWeek > startOfWeek, "End of week should be after start of week")

            // End of week should be just before start of next week
            let nextWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
            let timeDifference = nextWeekStart.timeIntervalSince(endOfWeek)
            XCTAssertEqual(timeDifference, 1.0, accuracy: 0.1, "End of week should be 1 second before next week start")
        }
    }

    // MARK: - Month Calculation Tests

    func testStartOfMonth() {
        let calendar = Calendar.gregorian

        let startOfMonth = calendar.startOfMonth(for: testDate)
        XCTAssertNotNil(startOfMonth, "Start of month should not be nil")

        if let startOfMonth = startOfMonth {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startOfMonth)

            XCTAssertEqual(components.year, 2024, "Year should be preserved")
            XCTAssertEqual(components.month, 3, "Month should be preserved")
            XCTAssertEqual(components.day, 1, "Day should be 1")
            XCTAssertEqual(components.hour, 0, "Hour should be 0")
            XCTAssertEqual(components.minute, 0, "Minute should be 0")
            XCTAssertEqual(components.second, 0, "Second should be 0")
        }
    }

    func testEndOfMonth() {
        let calendar = Calendar.gregorian

        let endOfMonth = calendar.endOfMonth(for: testDate)
        XCTAssertNotNil(endOfMonth, "End of month should not be nil")

        if let endOfMonth = endOfMonth {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endOfMonth)

            XCTAssertEqual(components.year, 2024, "Year should be preserved")
            XCTAssertEqual(components.month, 3, "Month should be preserved")
            XCTAssertEqual(components.day, 31, "Day should be 31 (March has 31 days)")
            XCTAssertEqual(components.hour, 23, "Hour should be 23")
            XCTAssertEqual(components.minute, 59, "Minute should be 59")
            XCTAssertEqual(components.second, 59, "Second should be 59")
        }
    }

    func testEndOfMonthFebruary() {
        let calendar = Calendar.gregorian

        // Test February in leap year
        var febComponents = DateComponents()
        febComponents.year = 2024
        febComponents.month = 2
        febComponents.day = 15
        let febDate = calendar.date(from: febComponents)!

        let endOfFeb = calendar.endOfMonth(for: febDate)!
        let components = calendar.dateComponents([.day], from: endOfFeb)

        XCTAssertEqual(components.day, 29, "February 2024 should end on day 29")
    }

    // MARK: - Year Calculation Tests

    func testStartOfYear() {
        let calendar = Calendar.gregorian

        let startOfYear = calendar.startOfYear(for: testDate)
        XCTAssertNotNil(startOfYear, "Start of year should not be nil")

        if let startOfYear = startOfYear {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startOfYear)

            XCTAssertEqual(components.year, 2024, "Year should be preserved")
            XCTAssertEqual(components.month, 1, "Month should be 1")
            XCTAssertEqual(components.day, 1, "Day should be 1")
            XCTAssertEqual(components.hour, 0, "Hour should be 0")
            XCTAssertEqual(components.minute, 0, "Minute should be 0")
            XCTAssertEqual(components.second, 0, "Second should be 0")
        }
    }

    func testEndOfYear() {
        let calendar = Calendar.gregorian

        let endOfYear = calendar.endOfYear(for: testDate)
        XCTAssertNotNil(endOfYear, "End of year should not be nil")

        if let endOfYear = endOfYear {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endOfYear)

            XCTAssertEqual(components.year, 2024, "Year should be preserved")
            XCTAssertEqual(components.month, 12, "Month should be 12")
            XCTAssertEqual(components.day, 31, "Day should be 31")
            XCTAssertEqual(components.hour, 23, "Hour should be 23")
            XCTAssertEqual(components.minute, 59, "Minute should be 59")
            XCTAssertEqual(components.second, 59, "Second should be 59")
        }
    }

    // MARK: - Edge Case Tests

    func testBoundaryDates() {
        let calendar = Calendar.gregorian

        // Test with first day of year
        var jan1Components = DateComponents()
        jan1Components.year = 2024
        jan1Components.month = 1
        jan1Components.day = 1
        let jan1 = calendar.date(from: jan1Components)!

        let startOfYear = calendar.startOfYear(for: jan1)!
        XCTAssertEqual(jan1.timeIntervalSince(startOfYear), 0, accuracy: 1.0, "Jan 1 should equal start of year")

        // Test with last day of year
        var dec31Components = DateComponents()
        dec31Components.year = 2024
        dec31Components.month = 12
        dec31Components.day = 31
        dec31Components.hour = 23
        dec31Components.minute = 59
        dec31Components.second = 59
        let dec31 = calendar.date(from: dec31Components)!

        let endOfYear = calendar.endOfYear(for: dec31)!
        XCTAssertEqual(dec31.timeIntervalSince(endOfYear), 0, accuracy: 1.0, "Dec 31 23:59:59 should equal end of year")
    }

    func testConsistencyAcrossMonths() {
        let calendar = Calendar.gregorian

        // Test that start of next month equals day after end of current month
        let startOfMonth = calendar.startOfMonth(for: testDate)!
        let endOfMonth = calendar.endOfMonth(for: testDate)!

        let nextMonth = calendar.date(byAdding: .second, value: 1, to: endOfMonth)!
        let startOfNextMonth = calendar.startOfMonth(for: nextMonth)!

        XCTAssertEqual(nextMonth.timeIntervalSince(startOfNextMonth), 0, accuracy: 1.0,
                       "Second after end of month should be start of next month")
    }
}
