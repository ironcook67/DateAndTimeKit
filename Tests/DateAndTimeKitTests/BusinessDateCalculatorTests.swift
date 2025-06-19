//
//  BusinessDateCalculatorTests.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import XCTest
@testable import DateAndTimeKit

/// Unit tests for BusinessDateCalculator functionality.
///
/// These tests verify business day calculations, weekend/holiday detection,
/// and business day arithmetic across various scenarios and edge cases.
final class BusinessDateCalculatorTests: XCTestCase {

    /// Test calculator instance
    private var calculator: BusinessDateCalculator!

    /// Test calendar for consistent date creation
    private var calendar: Calendar!

    /// Monday, June 17, 2024
    private var monday: Date!

    /// Tuesday, June 18, 2024
    private var tuesday: Date!

    /// Friday, June 21, 2024
    private var friday: Date!

    /// Saturday, June 22, 2024
    private var saturday: Date!

    /// Sunday, June 23, 2024
    private var sunday: Date!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calculator = BusinessDateCalculator(calendar: calendar)

        // Create test dates for June 2024
        monday = createDate(year: 2024, month: 6, day: 17)! // Monday
        tuesday = createDate(year: 2024, month: 6, day: 18)! // Tuesday
        friday = createDate(year: 2024, month: 6, day: 21)! // Friday
        saturday = createDate(year: 2024, month: 6, day: 22)! // Saturday
        sunday = createDate(year: 2024, month: 6, day: 23)! // Sunday
    }

    override func tearDown() {
        calculator = nil
        calendar = nil
        monday = nil
        tuesday = nil
        friday = nil
        saturday = nil
        sunday = nil
        super.tearDown()
    }

    // MARK: - Helper Methods

    private func createDate(year: Int, month: Int, day: Int, hour: Int = 9, minute: Int = 0) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)
    }

    // MARK: - Business Day Detection Tests

    func testIsBusinessDayWeekdays() {
        XCTAssertTrue(calculator.isBusinessDay(monday), "Monday should be a business day")
        XCTAssertTrue(calculator.isBusinessDay(tuesday), "Tuesday should be a business day")
        XCTAssertTrue(calculator.isBusinessDay(friday), "Friday should be a business day")
    }

    func testIsBusinessDayWeekends() {
        XCTAssertFalse(calculator.isBusinessDay(saturday), "Saturday should not be a business day")
        XCTAssertFalse(calculator.isBusinessDay(sunday), "Sunday should not be a business day")
    }

    func testIsBusinessDayWithHolidays() {
        let july4th = createDate(year: 2024, month: 7, day: 4)! // Thursday, July 4, 2024
        let calculatorWithHoliday = calculator.addingHolidays([july4th])

        XCTAssertTrue(calculator.isBusinessDay(july4th), "July 4th should be business day without holiday")
        XCTAssertFalse(calculatorWithHoliday.isBusinessDay(july4th), "July 4th should not be business day with holiday")
    }

    func testIsWeekend() {
        XCTAssertFalse(calculator.isWeekend(monday), "Monday should not be weekend")
        XCTAssertFalse(calculator.isWeekend(friday), "Friday should not be weekend")
        XCTAssertTrue(calculator.isWeekend(saturday), "Saturday should be weekend")
        XCTAssertTrue(calculator.isWeekend(sunday), "Sunday should be weekend")
    }

    func testIsHoliday() {
        let july4th = createDate(year: 2024, month: 7, day: 4)!
        let calculatorWithHoliday = calculator.addingHolidays([july4th])

        XCTAssertFalse(calculator.isHoliday(july4th), "Should not be holiday without configuration")
        XCTAssertTrue(calculatorWithHoliday.isHoliday(july4th), "Should be holiday with configuration")
        XCTAssertFalse(calculatorWithHoliday.isHoliday(monday), "Regular day should not be holiday")
    }

    // MARK: - Business Day Navigation Tests

    func testNextBusinessDayFromWeekday() {
        let nextBusinessDay = calculator.nextBusinessDay(from: monday)
        XCTAssertEqual(nextBusinessDay, tuesday, "Next business day from Monday should be Tuesday")
    }

    func testNextBusinessDayFromFriday() {
        let nextMonday = createDate(year: 2024, month: 6, day: 24)! // Monday, June 24
        let nextBusinessDay = calculator.nextBusinessDay(from: friday)
        XCTAssertEqual(nextBusinessDay, nextMonday, "Next business day from Friday should be next Monday")
    }

    func testNextBusinessDayFromSaturday() {
        let nextMonday = createDate(year: 2024, month: 6, day: 24)! // Monday, June 24
        let nextBusinessDay = calculator.nextBusinessDay(from: saturday)
        XCTAssertEqual(nextBusinessDay, nextMonday, "Next business day from Saturday should be Monday")
    }

    func testPreviousBusinessDayFromTuesday() {
        let prevBusinessDay = calculator.previousBusinessDay(from: tuesday)
        XCTAssertEqual(prevBusinessDay, monday, "Previous business day from Tuesday should be Monday")
    }

    func testPreviousBusinessDayFromMonday() {
        let prevFriday = createDate(year: 2024, month: 6, day: 14)! // Friday, June 14
        let prevBusinessDay = calculator.previousBusinessDay(from: monday)
        XCTAssertEqual(prevBusinessDay, prevFriday, "Previous business day from Monday should be previous Friday")
    }

    func testClosestBusinessDayToBusinessDay() {
        let closest = calculator.closestBusinessDay(to: tuesday)
        XCTAssertEqual(closest, tuesday, "Closest business day to Tuesday should be Tuesday itself")
    }

    func testClosestBusinessDayToWeekend() {
        let nextMonday = createDate(year: 2024, month: 6, day: 24)! // Monday, June 24
        let closest = calculator.closestBusinessDay(to: saturday)
        XCTAssertEqual(closest, nextMonday, "Closest business day to Saturday should be next Monday")
    }

    // MARK: - Business Day Arithmetic Tests

    func testAddBusinessDaysPositive() {
        // Add 3 business days to Monday: Monday -> Tuesday -> Wednesday -> Thursday
        let result = calculator.addBusinessDays(3, to: monday)
        let expectedThursday = createDate(year: 2024, month: 6, day: 20)! // Thursday
        XCTAssertEqual(result, expectedThursday, "Adding 3 business days to Monday should give Thursday")
    }

    func testAddBusinessDaysOverWeekend() {
        // Add 5 business days to Monday: should skip weekend and land on next Monday
        let result = calculator.addBusinessDays(5, to: monday)
        let expectedNextMonday = createDate(year: 2024, month: 6, day: 24)! // Monday, June 24
        XCTAssertEqual(result, expectedNextMonday, "Adding 5 business days to Monday should give next Monday")
    }

    func testAddBusinessDaysZero() {
        let result = calculator.addBusinessDays(0, to: tuesday)
        XCTAssertEqual(result, tuesday, "Adding 0 business days should return same date")
    }

    func testAddBusinessDaysNegative() {
        // Subtract 2 business days from Wednesday (June 19)
        let wednesday = createDate(year: 2024, month: 6, day: 19)!
        let result = calculator.addBusinessDays(-2, to: wednesday)
        XCTAssertEqual(result, monday, "Subtracting 2 business days from Wednesday should give Monday")
    }

    func testSubtractBusinessDays() {
        let result = calculator.subtractBusinessDays(1, from: tuesday)
        XCTAssertEqual(result, monday, "Subtracting 1 business day from Tuesday should give Monday")
    }

    func testAddBusinessDaysWithHolidays() {
        let july3rd = createDate(year: 2024, month: 7, day: 3)! // Wednesday
        let july4th = createDate(year: 2024, month: 7, day: 4)! // Thursday (holiday)
        let july5th = createDate(year: 2024, month: 7, day: 5)! // Friday

        let calculatorWithHoliday = calculator.addingHolidays([july4th])

        // Add 2 business days from Wednesday: should skip Thursday (holiday) and land on Friday
        let result = calculatorWithHoliday.addBusinessDays(2, to: july3rd)
        XCTAssertEqual(result, july5th, "Should skip holiday when adding business days")
    }

    // MARK: - Business Day Counting Tests

    func testBusinessDaysBetweenSameWeek() {
        // Monday to Friday of same week = 5 business days
        let count = calculator.businessDaysBetween(monday, and: friday)
        XCTAssertEqual(count, 5, "Monday to Friday should be 5 business days")
    }

    func testBusinessDaysBetweenWithWeekend() {
        // Friday to next Monday = 2 business days (Friday + Monday)
        let nextMonday = createDate(year: 2024, month: 6, day: 24)!
        let count = calculator.businessDaysBetween(friday, and: nextMonday)
        XCTAssertEqual(count, 2, "Friday to next Monday should be 2 business days")
    }

    func testBusinessDaysBetweenSameDay() {
        let count = calculator.businessDaysBetween(tuesday, and: tuesday)
        XCTAssertEqual(count, 1, "Same business day should count as 1")
    }

    func testBusinessDaysBetweenReverseOrder() {
        let count = calculator.businessDaysBetween(friday, and: monday)
        XCTAssertEqual(count, 5, "Order should not matter for counting business days")
    }

    func testBusinessDaysBetweenWithHolidays() {
        let july1st = createDate(year: 2024, month: 7, day: 1)! // Monday
        let july4th = createDate(year: 2024, month: 7, day: 4)! // Thursday (holiday)
        let july5th = createDate(year: 2024, month: 7, day: 5)! // Friday

        let calculatorWithHoliday = calculator.addingHolidays([july4th])

        // July 1-5: Mon, Tue, Wed, (Thu holiday), Fri = 4 business days
        let count = calculatorWithHoliday.businessDaysBetween(july1st, and: july5th)
        XCTAssertEqual(count, 4, "Should exclude holiday from business day count")
    }

    func testBusinessDaysBetweenWeekendOnly() {
        let count = calculator.businessDaysBetween(saturday, and: sunday)
        XCTAssertEqual(count, 0, "Weekend days should contribute 0 business days")
    }

    // MARK: - Holiday Management Tests

    func testAddingHolidays() {
        let july4th = createDate(year: 2024, month: 7, day: 4)!
        let newYears = createDate(year: 2024, month: 1, day: 1)!

        let calculatorWithHolidays = calculator.addingHolidays([july4th, newYears])

        XCTAssertTrue(calculatorWithHolidays.isHoliday(july4th), "July 4th should be holiday")
        XCTAssertTrue(calculatorWithHolidays.isHoliday(newYears), "New Year's should be holiday")
        XCTAssertFalse(calculatorWithHolidays.isHoliday(monday), "Regular day should not be holiday")
    }

    func testWithWeekendDays() {
        // Create calculator for Middle Eastern countries (Friday-Saturday weekend)
        let fridaySaturdayCalculator = calculator.withWeekendDays([6, 7]) // Friday=6, Saturday=7

        let fridayDate = createDate(year: 2024, month: 6, day: 21)! // Friday
        let saturdayDate = createDate(year: 2024, month: 6, day: 22)! // Saturday
        let sundayDate = createDate(year: 2024, month: 6, day: 23)! // Sunday

        XCTAssertTrue(fridaySaturdayCalculator.isWeekend(fridayDate), "Friday should be weekend")
        XCTAssertTrue(fridaySaturdayCalculator.isWeekend(saturdayDate), "Saturday should be weekend")
        XCTAssertFalse(fridaySaturdayCalculator.isWeekend(sundayDate), "Sunday should not be weekend")

        XCTAssertFalse(fridaySaturdayCalculator.isBusinessDay(fridayDate), "Friday should not be business day")
        XCTAssertTrue(fridaySaturdayCalculator.isBusinessDay(sundayDate), "Sunday should be business day")
    }

    // MARK: - Edge Case Tests

    func testMonthBoundary() {
        let endOfJune = createDate(year: 2024, month: 6, day: 28)! // Friday, June 28
        let nextBusinessDay = calculator.nextBusinessDay(from: endOfJune)
        let expectedMonday = createDate(year: 2024, month: 7, day: 1)! // Monday, July 1

        XCTAssertEqual(nextBusinessDay, expectedMonday, "Should handle month boundary correctly")
    }

    func testYearBoundary() {
        let endOfYear = createDate(year: 2023, month: 12, day: 29)! // Friday, Dec 29
        let nextBusinessDay = calculator.nextBusinessDay(from: endOfYear)
        let expectedMonday = createDate(year: 2024, month: 1, day: 1)! // Monday, Jan 1

        XCTAssertEqual(nextBusinessDay, expectedMonday, "Should handle year boundary correctly")
    }

    func testLeapYearFebruary() {
        let feb28 = createDate(year: 2024, month: 2, day: 28)! // Wednesday
        let feb29 = createDate(year: 2024, month: 2, day: 29)! // Thursday (leap day)

        let nextBusinessDay = calculator.nextBusinessDay(from: feb28)
        XCTAssertEqual(nextBusinessDay, feb29, "Should handle leap year February correctly")

        XCTAssertTrue(calculator.isBusinessDay(feb29), "Feb 29 should be a business day")
    }

    func testLongHolidayWeekend() {
        // Test a long weekend with holiday on Friday
        let thursday = createDate(year: 2024, month: 7, day: 4)! // Thursday, July 4 (holiday)
//        let friday = createDate(year: 2024, month: 7, day: 5)! // Friday
        let calculatorWithHoliday = calculator.addingHolidays([thursday])

        let nextBusinessDay = calculatorWithHoliday.nextBusinessDay(from: thursday)
        let expectedMonday = createDate(year: 2024, month: 7, day: 8)! // Monday

        XCTAssertEqual(nextBusinessDay!, expectedMonday, "Should skip long holiday weekend")
    }

    func testHolidayOnWeekend() {
        // Holiday that falls on Saturday should not affect business day calculations
        let holidaySaturday = createDate(year: 2024, month: 6, day: 22)! // Saturday
        let calculatorWithWeekendHoliday = calculator.addingHolidays([holidaySaturday])

        XCTAssertFalse(calculatorWithWeekendHoliday.isBusinessDay(holidaySaturday),
                       "Weekend holiday should not be business day")

        let nextBusinessDay = calculatorWithWeekendHoliday.nextBusinessDay(from: friday)
        let expectedMonday = createDate(year: 2024, month: 6, day: 24)!

        XCTAssertEqual(nextBusinessDay, expectedMonday, "Weekend holiday should not affect next business day")
    }

    // MARK: - Performance Tests

    func testBusinessDayCalculationPerformance() {
        measure {
            for _ in 0..<100 {
                _ = calculator.addBusinessDays(10, to: monday)
                _ = calculator.businessDaysBetween(monday, and: friday)
                _ = calculator.nextBusinessDay(from: saturday)
            }
        }
    }

    func testLargeBusinessDayAddition() {
        // Test adding a large number of business days
        let result = calculator.addBusinessDays(250, to: monday) // About 50 weeks
        XCTAssertNotNil(result, "Should handle large business day additions")

        if let result = result {
            let daysDifference = calculator.businessDaysBetween(monday, and: result)
            XCTAssertEqual(daysDifference!, 250, "Should count correct number of business days")
        }
    }

    // MARK: - Consistency Tests

    func testBusinessDayArithmeticConsistency() {
        // Adding and subtracting should be inverse operations
        let originalDate = tuesday
        let added = calculator.addBusinessDays(5, to: originalDate!)
        XCTAssertNotNil(added, "Adding business days should succeed")

        if let added = added {
            let subtracted = calculator.subtractBusinessDays(5, from: added)
            XCTAssertEqual(subtracted, originalDate, "Adding then subtracting should return original date")
        }
    }

    func testBusinessDayCountingConsistency() {
        // Count from A to B should equal reverse count from B to A
        let countAtoB = calculator.businessDaysBetween(monday, and: friday)
        let countBtoA = calculator.businessDaysBetween(friday, and: monday)

        XCTAssertEqual(countAtoB, countBtoA, "Business day counting should be symmetric")
    }

    func testBusinessDayNavigationConsistency() {
        // Going forward then backward should maintain consistency
        if let next = calculator.nextBusinessDay(from: friday),
           let prev = calculator.previousBusinessDay(from: next) {
            XCTAssertEqual(prev, friday, "Next then previous should return to original business day")
        }
    }
}
