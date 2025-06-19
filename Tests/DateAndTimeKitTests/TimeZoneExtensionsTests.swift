//
//  TimeZoneExtensionsTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for TimeZone extensions.
///
/// These tests verify the convenience properties for common timezones,
/// ensuring they return the correct timezone instances and abbreviations.
final class TimeZoneExtensionsTests: XCTestCase {

    // MARK: - UTC TimeZone Tests

    func testUTCTimeZone() {
        let utcTimeZone = TimeZone.utc

        XCTAssertEqual(utcTimeZone.abbreviation(), "UTC", "UTC timezone should have UTC abbreviation")
        XCTAssertEqual(utcTimeZone.secondsFromGMT(), 0, "UTC should have 0 offset from GMT")
        XCTAssertEqual(utcTimeZone.identifier, "UTC", "UTC should have UTC identifier")
    }

    func testUTCTimeZoneConsistency() {
        let utc1 = TimeZone.utc
        let utc2 = TimeZone.utc
        let utc3 = TimeZone(abbreviation: "UTC")!

        XCTAssertEqual(utc1, utc2, "Multiple calls should return same timezone")
        XCTAssertEqual(utc1, utc3, "Should equal manually created UTC timezone")
        XCTAssertEqual(utc1.identifier, utc3.identifier, "Identifiers should match")
    }

    // MARK: - GMT TimeZone Tests

    func testGMTTimeZone() {
        let gmtTimeZone = TimeZone.gmt

        XCTAssertEqual(gmtTimeZone.abbreviation(), "GMT", "GMT timezone should have GMT abbreviation")
        XCTAssertEqual(gmtTimeZone.secondsFromGMT(), 0, "GMT should have 0 offset from GMT")

        // GMT and UTC should be equivalent in terms of offset
        XCTAssertEqual(gmtTimeZone.secondsFromGMT(), TimeZone.utc.secondsFromGMT(),
                       "GMT and UTC should have same offset")
    }

    func testGMTTimeZoneConsistency() {
        let gmt1 = TimeZone.gmt
        let gmt2 = TimeZone.gmt
        let gmt3 = TimeZone(abbreviation: "GMT")!

        XCTAssertEqual(gmt1, gmt2, "Multiple calls should return same timezone")
        XCTAssertEqual(gmt1, gmt3, "Should equal manually created GMT timezone")
    }

    // MARK: - EST TimeZone Tests

    func testESTTimeZone() {
        let estTimeZone = TimeZone.est

        XCTAssertEqual(estTimeZone.abbreviation(), "EST", "EST timezone should have EST abbreviation")

        // EST is UTC-5, so should be -5 * 3600 = -18000 seconds from GMT
        let expectedOffset = -5 * 3600
        XCTAssertEqual(estTimeZone.secondsFromGMT(), expectedOffset,
                       "EST should be 5 hours behind GMT")
    }

    func testESTTimeZoneConsistency() {
        let est1 = TimeZone.est
        let est2 = TimeZone.est
        let est3 = TimeZone(abbreviation: "EST")!

        XCTAssertEqual(est1, est2, "Multiple calls should return same timezone")
        XCTAssertEqual(est1, est3, "Should equal manually created EST timezone")
    }

    // MARK: - PST TimeZone Tests

    func testPSTTimeZone() {
        let pstTimeZone = TimeZone.pst

        XCTAssertEqual(pstTimeZone.abbreviation(), "PST", "PST timezone should have PST abbreviation")

        // PST is UTC-8, so should be -8 * 3600 = -28800 seconds from GMT
        let expectedOffset = -8 * 3600
        XCTAssertEqual(pstTimeZone.secondsFromGMT(), expectedOffset,
                       "PST should be 8 hours behind GMT")
    }

    func testPSTTimeZoneConsistency() {
        let pst1 = TimeZone.pst
        let pst2 = TimeZone.pst
        let pst3 = TimeZone(abbreviation: "PST")!

        XCTAssertEqual(pst1, pst2, "Multiple calls should return same timezone")
        XCTAssertEqual(pst1, pst3, "Should equal manually created PST timezone")
    }

    // MARK: - TimeZone Relationship Tests

    func testTimeZoneOffsetRelationships() {
        let utc = TimeZone.utc
        let gmt = TimeZone.gmt
        let est = TimeZone.est
        let pst = TimeZone.pst

        // Test offset relationships
        XCTAssertEqual(utc.secondsFromGMT(), gmt.secondsFromGMT(),
                       "UTC and GMT should have same offset")

        XCTAssertLessThan(est.secondsFromGMT(), utc.secondsFromGMT(),
                          "EST should be behind UTC")

        XCTAssertLessThan(pst.secondsFromGMT(), est.secondsFromGMT(),
                          "PST should be behind EST")

        // Test specific differences
        let estToUTCDifference = utc.secondsFromGMT() - est.secondsFromGMT()
        XCTAssertEqual(estToUTCDifference, 5 * 3600, "EST should be 5 hours behind UTC")

        let pstToUTCDifference = utc.secondsFromGMT() - pst.secondsFromGMT()
        XCTAssertEqual(pstToUTCDifference, 8 * 3600, "PST should be 8 hours behind UTC")

        let estToPSTDifference = pst.secondsFromGMT() - est.secondsFromGMT()
        XCTAssertEqual(estToPSTDifference, -3 * 3600, "PST should be 3 hours behind EST")
    }

    // MARK: - Date Formatting Tests with TimeZones

    func testTimeZonesWithDateFormatting() {
        // Create a test date: January 15, 2024 at 12:00 PM UTC
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 15
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.utc

        let testDate = Calendar.current.date(from: components)!

        // Test formatting in different timezones
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"

        formatter.timeZone = TimeZone.utc
        let utcString = formatter.string(from: testDate)
        XCTAssertTrue(utcString.contains("UTC") || utcString.contains("GMT"),
                      "UTC formatting should contain UTC or GMT")

        formatter.timeZone = TimeZone.est
        let estString = formatter.string(from: testDate)
        XCTAssertTrue(estString.contains("EST"), "EST formatting should contain EST")
        XCTAssertTrue(estString.contains("07:00"), "EST should show 7:00 AM (5 hours earlier)")

        formatter.timeZone = TimeZone.pst
        let pstString = formatter.string(from: testDate)
        XCTAssertTrue(pstString.contains("PST"), "PST formatting should contain PST")
        XCTAssertTrue(pstString.contains("04:00"), "PST should show 4:00 AM (8 hours earlier)")
    }

    // MARK: - Error Handling Tests

    func testTimeZoneCreationDoesNotFail() {
        // These should not crash or return nil since they're force unwrapped
        XCTAssertNoThrow(TimeZone.utc, "UTC timezone creation should not fail")
        XCTAssertNoThrow(TimeZone.gmt, "GMT timezone creation should not fail")
        XCTAssertNoThrow(TimeZone.est, "EST timezone creation should not fail")
        XCTAssertNoThrow(TimeZone.pst, "PST timezone creation should not fail")

        // Verify they're not nil
        XCTAssertNotNil(TimeZone.utc, "UTC should not be nil")
        XCTAssertNotNil(TimeZone.gmt, "GMT should not be nil")
        XCTAssertNotNil(TimeZone.est, "EST should not be nil")
        XCTAssertNotNil(TimeZone.pst, "PST should not be nil")
    }

    // MARK: - Performance Tests

    func testTimeZoneAccessPerformance() {
        // Test that accessing timezone properties is reasonably fast
        measure {
            for _ in 0..<1000 {
                _ = TimeZone.utc
                _ = TimeZone.gmt
                _ = TimeZone.est
                _ = TimeZone.pst
            }
        }
    }

    // MARK: - Integration Tests

    func testTimeZonesWithDateCalculator() {
        // Test that our timezone extensions work well with DateCalculator
        let calculator = DateCalculator()

        // Create a date in EST
        var components = DateComponents()
        components.year = 2024
        components.month = 6
        components.day = 18
        components.hour = 14
        components.minute = 30
        components.timeZone = TimeZone.est

        let estDate = Calendar.current.date(from: components)!

        // Use calculator methods
        let startOfDay = calculator.startOfDay(for: estDate)
        let endOfDay = calculator.endOfDay(for: estDate)

        XCTAssertTrue(calculator.areSameDay(estDate, startOfDay),
                      "Start of day should be same day as original")
        XCTAssertTrue(calculator.areSameDay(estDate, endOfDay),
                      "End of day should be same day as original")
    }

    func testTimeZonesWithFormatters() {
        // Test that our timezone extensions work with StandardDateFormatters
        let testDate = Date()

        // Create formatters with our timezone extensions
        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        utcFormatter.timeZone = TimeZone.utc

        let estFormatter = DateFormatter()
        estFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        estFormatter.timeZone = TimeZone.est

        let pstFormatter = DateFormatter()
        pstFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        pstFormatter.timeZone = TimeZone.pst

        // Format the same date in different timezones
        let utcString = utcFormatter.string(from: testDate)
        let estString = estFormatter.string(from: testDate)
        let pstString = pstFormatter.string(from: testDate)

        // They should all be valid date strings but different times
        XCTAssertNotEqual(utcString, estString, "UTC and EST should show different times")
        XCTAssertNotEqual(estString, pstString, "EST and PST should show different times")
        XCTAssertNotEqual(utcString, pstString, "UTC and PST should show different times")

        // Verify format structure
        XCTAssertTrue(utcString.matches("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"),
                      "UTC string should match expected format")
        XCTAssertTrue(estString.matches("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"),
                      "EST string should match expected format")
        XCTAssertTrue(pstString.matches("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"),
                      "PST string should match expected format")
    }
}

// MARK: - String Extension for Regex Matching

private extension String {
    func matches(_ pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
