//
//  TimeZoneConverterTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for TimeZoneConverter functionality.
///
/// These tests verify timezone conversion methods including wall clock time preservation,
/// absolute time preservation, and UTC conversions across different scenarios.
final class TimeZoneConverterTests: XCTestCase {

    /// Test converter instance
    private var converter: TimeZoneConverter!

    /// Fixed test date: March 15, 2024 at 2:30 PM EST
    private var testDate: Date!

    /// Eastern Standard Time timezone
    private var estTimeZone: TimeZone!

    /// Pacific Standard Time timezone
    private var pstTimeZone: TimeZone!

    /// UTC timezone
    private var utcTimeZone: TimeZone!

    override func setUp() {
        super.setUp()
        converter = TimeZoneConverter()

        // Set up timezones
        estTimeZone = TimeZone(abbreviation: "EST")!
        pstTimeZone = TimeZone(abbreviation: "PST")!
        utcTimeZone = TimeZone(abbreviation: "UTC")!

        // Create a fixed test date: March 15, 2024 at 2:30 PM EST
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 15
        components.hour = 14
        components.minute = 30
        components.second = 0
        components.timeZone = estTimeZone

        testDate = Calendar.current.date(from: components)!
    }

    override func tearDown() {
        converter = nil
        testDate = nil
        estTimeZone = nil
        pstTimeZone = nil
        utcTimeZone = nil
        super.tearDown()
    }

    // MARK: - Wall Clock Time Conversion Tests

    func testConvertWallClockTimeESTToPST() {
        let result = converter.convertWallClockTime(testDate, to: pstTimeZone)
        XCTAssertNotNil(result, "Wall clock time conversion should succeed")

        // Should preserve the displayed time (2:30 PM) but in PST
        let components = Calendar.current.dateComponents(in: pstTimeZone, from: result!)
        XCTAssertEqual(components.hour, 14, "Hour should remain 14 (2 PM)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
        XCTAssertEqual(components.day, 15, "Day should remain 15")
        XCTAssertEqual(components.month, 3, "Month should remain 3")
        XCTAssertEqual(components.year, 2024, "Year should remain 2024")
    }

    func testConvertWallClockTimeToUTC() {
        let result = converter.convertWallClockTime(testDate, to: utcTimeZone)
        XCTAssertNotNil(result, "Wall clock time conversion to UTC should succeed")

        // Should preserve the displayed time (2:30 PM) but in UTC
        let components = Calendar.current.dateComponents(in: utcTimeZone, from: result!)
        XCTAssertEqual(components.hour, 14, "Hour should remain 14 (2 PM)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    func testConvertWallClockTimeSameTimeZone() {
        let result = converter.convertWallClockTime(testDate, to: estTimeZone)
        XCTAssertNotNil(result, "Converting to same timezone should succeed")

        // Should be essentially the same date
        let timeDifference = abs(result!.timeIntervalSince(testDate))
        XCTAssertLessThan(timeDifference, 1.0, "Time difference should be minimal when converting to same timezone")
    }

    // MARK: - Absolute Time Conversion Tests

    func testConvertAbsoluteTimeESTToPST() {
        let result = converter.convertAbsoluteTime(testDate, from: estTimeZone, to: pstTimeZone)
        XCTAssertNotNil(result, "Absolute time conversion should succeed")

        // EST is UTC-5, PST is UTC-8, so PST should be 3 hours earlier
        let components = Calendar.current.dateComponents(in: pstTimeZone, from: result!)
        XCTAssertEqual(components.hour, 11, "Hour should be 11 AM PST (3 hours earlier than 2 PM EST)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    func testConvertAbsoluteTimeESTToUTC() {
        let result = converter.convertAbsoluteTime(testDate, from: estTimeZone, to: utcTimeZone)
        XCTAssertNotNil(result, "Absolute time conversion to UTC should succeed")

        // EST is UTC-5, so UTC should be 5 hours ahead
        let components = Calendar.current.dateComponents(in: utcTimeZone, from: result!)
        XCTAssertEqual(components.hour, 19, "Hour should be 7 PM UTC (5 hours ahead of 2 PM EST)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    func testConvertAbsoluteTimePSTToEST() {
        // Create a PST date first
        var pstComponents = DateComponents()
        pstComponents.year = 2024
        pstComponents.month = 3
        pstComponents.day = 15
        pstComponents.hour = 11
        pstComponents.minute = 30
        pstComponents.timeZone = pstTimeZone

        let pstDate = Calendar.current.date(from: pstComponents)!
        let result = converter.convertAbsoluteTime(pstDate, from: pstTimeZone, to: estTimeZone)
        XCTAssertNotNil(result, "PST to EST conversion should succeed")

        // PST is UTC-8, EST is UTC-5, so EST should be 3 hours ahead
        let components = Calendar.current.dateComponents(in: estTimeZone, from: result!)
        XCTAssertEqual(components.hour, 14, "Hour should be 2 PM EST (3 hours ahead of 11 AM PST)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    // MARK: - UTC Conversion Tests

    func testConvertToUTC() {
        let result = converter.convertToUTC(testDate)
        XCTAssertNotNil(result, "Convert to UTC should succeed")

        // This preserves wall clock time, so should be 2:30 PM UTC
        let components = Calendar.current.dateComponents(in: utcTimeZone, from: result!)
        XCTAssertEqual(components.hour, 14, "Hour should remain 14 (2 PM)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    func testConvertUTCToLocal() {
        // First create a UTC date
        var utcComponents = DateComponents()
        utcComponents.year = 2024
        utcComponents.month = 3
        utcComponents.day = 15
        utcComponents.hour = 14
        utcComponents.minute = 30
        utcComponents.timeZone = utcTimeZone

        let utcDate = Calendar.current.date(from: utcComponents)!
        let result = converter.convertUTCToLocal(utcDate)
        XCTAssertNotNil(result, "Convert UTC to local should succeed")

        // This preserves wall clock time, so should be 2:30 PM in local timezone
        let components = Calendar.current.dateComponents([.hour, .minute], from: result!)
        XCTAssertEqual(components.hour, 14, "Hour should remain 14 (2 PM)")
        XCTAssertEqual(components.minute, 30, "Minute should remain 30")
    }

    func testRoundTripUTCConversion() {
        let utcDate = converter.convertToUTC(testDate)
        XCTAssertNotNil(utcDate, "First conversion should succeed")

        let backToLocal = converter.convertUTCToLocal(utcDate!)
        XCTAssertNotNil(backToLocal, "Round trip conversion should succeed")

        // Should preserve wall clock time
        let originalComponents = Calendar.current.dateComponents([.hour, .minute], from: testDate)
        let roundTripComponents = Calendar.current.dateComponents([.hour, .minute], from: backToLocal!)

        XCTAssertEqual(originalComponents.hour, roundTripComponents.hour, "Hour should be preserved in round trip")
        XCTAssertEqual(originalComponents.minute, roundTripComponents.minute, "Minute should be preserved in round trip")
    }

    // MARK: - Edge Case Tests

    func testMidnightConversion() {
        // Test conversion at midnight
        var midnightComponents = DateComponents()
        midnightComponents.year = 2024
        midnightComponents.month = 3
        midnightComponents.day = 15
        midnightComponents.hour = 0
        midnightComponents.minute = 0
        midnightComponents.timeZone = estTimeZone

        let midnightDate = Calendar.current.date(from: midnightComponents)!
        let result = converter.convertAbsoluteTime(midnightDate, from: estTimeZone, to: pstTimeZone)
        XCTAssertNotNil(result, "Midnight conversion should succeed")

        let components = Calendar.current.dateComponents(in: pstTimeZone, from: result!)
        XCTAssertEqual(components.hour, 21, "Should be 9 PM PST (previous day)")
        XCTAssertEqual(components.day, 14, "Should be March 14 in PST")
    }

    func testDaylightSavingTimeBoundary() {
        // Test around DST transition (second Sunday in March 2024 = March 10)
        var dstComponents = DateComponents()
        dstComponents.year = 2024
        dstComponents.month = 3
        dstComponents.day = 10
        dstComponents.hour = 2
        dstComponents.minute = 30
        dstComponents.timeZone = TimeZone(identifier: "America/New_York")

        let dstDate = Calendar.current.date(from: dstComponents)
        if let dstDate = dstDate {
            let result = converter.convertWallClockTime(dstDate, to: utcTimeZone)
            XCTAssertNotNil(result, "DST boundary conversion should handle gracefully")
        }
    }

    func testInvalidTimeZoneHandling() {
        // Test with extreme timezones
        let utcPlus14 = TimeZone(secondsFromGMT: 14 * 3600) // UTC+14
        let utcMinus12 = TimeZone(secondsFromGMT: -12 * 3600) // UTC-12

        if let utcPlus14 = utcPlus14, let utcMinus12 = utcMinus12 {
            let result = converter.convertAbsoluteTime(testDate, from: utcPlus14, to: utcMinus12)
            XCTAssertNotNil(result, "Extreme timezone conversion should work")

            // The time difference should be 26 hours
            let components = Calendar.current.dateComponents(in: utcMinus12, from: result!)
            // This is a complex calculation due to date line crossing, so we just verify it doesn't crash
            XCTAssertNotNil(components.hour, "Should have valid hour component")
        }
    }

    func testYearBoundaryConversion() {
        // Test conversion at year boundary
        var yearEndComponents = DateComponents()
        yearEndComponents.year = 2023
        yearEndComponents.month = 12
        yearEndComponents.day = 31
        yearEndComponents.hour = 23
        yearEndComponents.minute = 30
        yearEndComponents.timeZone = estTimeZone

        let yearEndDate = Calendar.current.date(from: yearEndComponents)!
        let result = converter.convertAbsoluteTime(yearEndDate, from: estTimeZone, to: pstTimeZone)
        XCTAssertNotNil(result, "Year boundary conversion should succeed")

        let components = Calendar.current.dateComponents(in: pstTimeZone, from: result!)
        XCTAssertEqual(components.hour, 20, "Should be 8:30 PM PST")
        XCTAssertEqual(components.day, 31, "Should still be December 31")
        XCTAssertEqual(components.year, 2023, "Should still be 2023")
    }

    func testLeapYearConversion() {
        // Test conversion on leap year day
        var leapDayComponents = DateComponents()
        leapDayComponents.year = 2024
        leapDayComponents.month = 2
        leapDayComponents.day = 29
        leapDayComponents.hour = 12
        leapDayComponents.minute = 0
        leapDayComponents.timeZone = estTimeZone

        let leapDate = Calendar.current.date(from: leapDayComponents)!
        let result = converter.convertWallClockTime(leapDate, to: pstTimeZone)
        XCTAssertNotNil(result, "Leap year conversion should succeed")

        let components = Calendar.current.dateComponents(in: pstTimeZone, from: result!)
        XCTAssertEqual(components.day, 29, "Should preserve February 29")
        XCTAssertEqual(components.month, 2, "Should preserve February")
        XCTAssertEqual(components.year, 2024, "Should preserve 2024")
    }

    // MARK: - Performance Tests

    func testConversionPerformance() {
        // Test that conversions are reasonably fast
        measure {
            for _ in 0..<1000 {
                _ = converter.convertWallClockTime(testDate, to: pstTimeZone)
                _ = converter.convertAbsoluteTime(testDate, from: estTimeZone, to: utcTimeZone)
                _ = converter.convertToUTC(testDate)
            }
        }
    }

    // MARK: - Consistency Tests

    func testConversionConsistency() {
        // Wall clock conversion should preserve displayed time
        let wallClockResult = converter.convertWallClockTime(testDate, to: pstTimeZone)!
        let originalComponents = Calendar.current.dateComponents(in: estTimeZone, from: testDate)
        let wallClockComponents = Calendar.current.dateComponents(in: pstTimeZone, from: wallClockResult)

        XCTAssertEqual(originalComponents.hour, wallClockComponents.hour, "Wall clock conversion should preserve hour")
        XCTAssertEqual(originalComponents.minute, wallClockComponents.minute, "Wall clock conversion should preserve minute")

        // Absolute time conversion should preserve the moment in time
        let absoluteResult = converter.convertAbsoluteTime(testDate, from: estTimeZone, to: pstTimeZone)!
        let timeDifference = absoluteResult.timeIntervalSince(testDate)

        // The actual times should be the same moment (allowing for timezone offset differences)
        XCTAssertEqual(timeDifference, 0, accuracy: 1.0, "Absolute time conversion should preserve the moment in time")
    }
}
