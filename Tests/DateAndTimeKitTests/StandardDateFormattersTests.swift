//
//  StandardDateFormattersTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for StandardDateFormatters functionality.
///
/// These tests verify the correct formatting and parsing of dates in various
/// formats and timezones, ensuring consistent behavior across different locales.
final class StandardDateFormattersTests: XCTestCase {

    /// Fixed test date: March 15, 2024 at 2:30 PM UTC
    private var testDate: Date!

    /// Expected date string in ISO 8601 format
    private let expectedDateString = "2024-03-15"

    /// Expected datetime string in ISO 8601 format
    private let expectedDateTimeString = "2024-03-15 14:30"

    override func setUp() {
        super.setUp()

        // Create a fixed test date for consistent testing
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 14
        components.minute = 30
        components.second = 0
        components.timeZone = TimeZone(abbreviation: "UTC")

        testDate = Calendar(identifier: .iso8601).date(from: components)!
    }

    override func tearDown() {
        testDate = nil
        super.tearDown()
    }

    // MARK: - ISO 8601 Date Formatter Tests

    func testISO8601DateFormatterProperties() {
        let formatter = StandardDateFormatters.iso8601Date

        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd", "Date format should be yyyy-MM-dd")
        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX", "Locale should be en_US_POSIX")
        XCTAssertEqual(formatter.calendar.identifier, .iso8601, "Calendar should be ISO 8601")
        XCTAssertEqual(formatter.timeZone, TimeZone.utc, "Timezone should be UTC")
    }

    func testISO8601DateFormatting() {
        let result = StandardDateFormatters.iso8601Date.string(from: testDate)
        XCTAssertEqual(result, expectedDateString, "Date should format to 2024-03-15")
    }

    func testISO8601DateParsing() {
        let result = StandardDateFormatters.iso8601Date.date(from: expectedDateString)
        XCTAssertNotNil(result, "Should parse valid ISO 8601 date string")

        let components = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day], from: result!)
        XCTAssertEqual(components.year, 2024, "Year should be 2024")
        XCTAssertEqual(components.month, 3, "Month should be 3")
        XCTAssertEqual(components.day, 15, "Day should be 15")
    }

    func testISO8601DateLocalFormatterProperties() {
        let formatter = StandardDateFormatters.iso8601DateLocal

        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd", "Date format should be yyyy-MM-dd")
        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX", "Locale should be en_US_POSIX")
        XCTAssertEqual(formatter.calendar.identifier, .iso8601, "Calendar should be ISO 8601")
        XCTAssertEqual(formatter.timeZone, TimeZone.current, "Timezone should be current")
    }

    // MARK: - ISO 8601 DateTime Formatter Tests

    func testISO8601DateTimeFormatterProperties() {
        let formatter = StandardDateFormatters.iso8601DateTime

        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd HH:mm", "DateTime format should be yyyy-MM-dd HH:mm")
        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX", "Locale should be en_US_POSIX")
        XCTAssertEqual(formatter.calendar.identifier, .iso8601, "Calendar should be ISO 8601")
        XCTAssertEqual(formatter.timeZone, TimeZone.utc, "Timezone should be UTC")
    }

    func testISO8601DateTimeFormatting() {
        let result = StandardDateFormatters.iso8601DateTime.string(from: testDate)
        XCTAssertEqual(result, expectedDateTimeString, "DateTime should format to 2024-03-15 14:30")
    }

    func testISO8601DateTimeParsing() {
        let result = StandardDateFormatters.iso8601DateTime.date(from: expectedDateTimeString)
        XCTAssertNotNil(result, "Should parse valid ISO 8601 datetime string")

        let components = Calendar(identifier: .iso8601).dateComponents([.year, .month, .day, .hour, .minute], from: result!)
        XCTAssertEqual(components.year, 2024, "Year should be 2024")
        XCTAssertEqual(components.month, 3, "Month should be 3")
        XCTAssertEqual(components.day, 15, "Day should be 15")
        XCTAssertEqual(components.hour, 14, "Hour should be 14")
        XCTAssertEqual(components.minute, 30, "Minute should be 30")
    }

    func testISO8601DateTimeLocalFormatterProperties() {
        let formatter = StandardDateFormatters.iso8601DateTimeLocal

        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd HH:mm", "DateTime format should be yyyy-MM-dd HH:mm")
        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX", "Locale should be en_US_POSIX")
        XCTAssertEqual(formatter.calendar.identifier, .iso8601, "Calendar should be ISO 8601")
        XCTAssertEqual(formatter.timeZone, TimeZone.current, "Timezone should be current")
    }

    // MARK: - Convenience Method Tests

    func testUTCDateStringConvenience() {
        let result = StandardDateFormatters.utcDateString(from: testDate)
        XCTAssertEqual(result, expectedDateString, "UTC date string should match expected format")
    }

    func testLocalDateStringConvenience() {
        let result = StandardDateFormatters.localDateString(from: testDate)
        XCTAssertEqual(result, expectedDateString, "Local date string should match expected format")
    }

    func testUTCDateParsingConvenience() {
        let result = StandardDateFormatters.utcDate(from: expectedDateString)
        XCTAssertNotNil(result, "Should parse valid date string")

        let formattedBack = StandardDateFormatters.utcDateString(from: result!)
        XCTAssertEqual(formattedBack, expectedDateString, "Round-trip parsing should work")
    }

    func testLocalDateParsingConvenience() {
        let result = StandardDateFormatters.localDate(from: expectedDateString)
        XCTAssertNotNil(result, "Should parse valid date string")

        let formattedBack = StandardDateFormatters.localDateString(from: result!)
        XCTAssertEqual(formattedBack, expectedDateString, "Round-trip parsing should work")
    }

    // MARK: - Edge Case Tests

    func testInvalidDateStringParsing() {
        let invalidStrings = [
            "invalid-date",
            "2024-13-01", // Invalid month
            "2024-02-30", // Invalid day for February
            "24-03-15",   // Wrong year format
            "2024/03/15", // Wrong separator
            ""            // Empty string
        ]

        for invalidString in invalidStrings {
            let result = StandardDateFormatters.utcDate(from: invalidString)
            XCTAssertNil(result, "Should not parse invalid date string: \(invalidString)")
        }
    }

    func testLeapYearFormatting() {
        // February 29, 2024 (leap year)
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 29
        components.timeZone = TimeZone(abbreviation: "UTC")

        let leapDate = Calendar(identifier: .iso8601).date(from: components)!
        let result = StandardDateFormatters.utcDateString(from: leapDate)

        XCTAssertEqual(result, "2024-02-29", "Should format leap year date correctly")
    }

    func testYearBoundaries() {
        // Test year 1 and year 9999
        let testCases = [
            (year: 1, expected: "0001-01-01"),
            (year: 9999, expected: "9999-12-31")
        ]

        for testCase in testCases {
            var components = DateComponents()
            components.year = testCase.year
            components.month = testCase.year == 1 ? 1 : 12
            components.day = testCase.year == 1 ? 1 : 31
            components.timeZone = TimeZone(abbreviation: "UTC")

            if let date = Calendar(identifier: .iso8601).date(from: components) {
                let result = StandardDateFormatters.utcDateString(from: date)
                XCTAssertEqual(result, testCase.expected, "Should format year \(testCase.year) correctly")
            }
        }
    }

    func testFormatterConsistency() {
        // Ensure that all formatters produce consistent results for the same date
        let utcDateString = StandardDateFormatters.iso8601Date.string(from: testDate)
        let utcDateTimeString = StandardDateFormatters.iso8601DateTime.string(from: testDate)

        XCTAssertTrue(utcDateTimeString.hasPrefix(utcDateString),
                      "DateTime string should start with date string")

        // Test that parsing and formatting are inverse operations
        let parsedDate = StandardDateFormatters.iso8601Date.date(from: utcDateString)!
        let reformattedString = StandardDateFormatters.iso8601Date.string(from: parsedDate)

        XCTAssertEqual(utcDateString, reformattedString,
                       "Parsing and formatting should be inverse operations")
    }
}
