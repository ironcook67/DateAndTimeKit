//
//  BusinessDateCalculator.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

/// A utility for calculating business days and handling weekends/holidays.
///
/// This struct provides methods for working with business days, excluding weekends
/// and optionally holidays from calculations. Useful for financial applications,
/// project planning, and any scenario where only working days matter.
///
/// ## Key Features
/// - Weekend detection and exclusion
/// - Holiday support with custom holiday sets
/// - Business day arithmetic (add/subtract business days)
/// - Business day counting between dates
///
/// ## Example Usage
/// ```swift
/// let calculator = BusinessDateCalculator()
/// let nextBusinessDay = calculator.nextBusinessDay(from: Date())
/// let businessDayCount = calculator.businessDaysBetween(startDate, and: endDate)
/// ```
public struct BusinessDateCalculator {

    /// The calendar used for date calculations
    private let calendar: Calendar

    /// Set of dates representing holidays to exclude from business day calculations
    private let holidays: Set<Date>

    /// Weekend days to exclude (default: Saturday and Sunday)
    private let weekendDays: Set<Int>

    /// Creates a new business date calculator.
    ///
    /// - Parameters:
    ///   - calendar: The calendar to use for calculations (defaults to current)
    ///   - holidays: Set of holiday dates to exclude (defaults to empty)
    ///   - weekendDays: Weekend days to exclude as weekday numbers (defaults to Saturday=7, Sunday=1)
    public init(calendar: Calendar = .current,
                holidays: Set<Date> = [],
                weekendDays: Set<Int> = [1, 7]) {
        self.calendar = calendar
        self.holidays = Set(holidays.map { calendar.startOfDay(for: $0) })
        self.weekendDays = weekendDays
    }

    // MARK: - Business Day Detection

    /// Determines if a given date is a business day.
    ///
    /// A business day is a weekday that is not a holiday.
    ///
    /// - Parameter date: The date to check
    /// - Returns: true if the date is a business day, false otherwise
    ///
    /// ## Example
    /// ```swift
    /// let isBusinessDay = calculator.isBusinessDay(Date()) // Returns false if it's Saturday/Sunday or a holiday
    /// ```
    public func isBusinessDay(_ date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)

        // Check if it's a weekend
        let weekday = calendar.component(.weekday, from: date)
        if weekendDays.contains(weekday) {
            return false
        }

        // Check if it's a holiday
        if holidays.contains(startOfDay) {
            return false
        }

        return true
    }

    /// Determines if a given date is a weekend.
    ///
    /// - Parameter date: The date to check
    /// - Returns: true if the date falls on a weekend, false otherwise
    public func isWeekend(_ date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekendDays.contains(weekday)
    }

    /// Determines if a given date is a holiday.
    ///
    /// - Parameter date: The date to check
    /// - Returns: true if the date is a configured holiday, false otherwise
    public func isHoliday(_ date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)
        return holidays.contains(startOfDay)
    }

    // MARK: - Business Day Navigation

    /// Returns the next business day from the given date.
    ///
    /// If the given date is already a business day, returns the next business day after it.
    ///
    /// - Parameter date: The starting date
    /// - Returns: The next business day, or nil if calculation fails
    ///
    /// ## Example
    /// ```swift
    /// let friday = // Some Friday
    /// let nextBusinessDay = calculator.nextBusinessDay(from: friday) // Returns the following Monday (unless it's a holiday)
    /// ```
    public func nextBusinessDay(from date: Date) -> Date? {
        var currentDate = calendar.date(byAdding: .day, value: 1, to: date) ?? date

        // Safety limit to prevent infinite loops
        let maxIterations = 10
        var iterations = 0

        while !isBusinessDay(currentDate) && iterations < maxIterations {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                return nil
            }
            currentDate = nextDate
            iterations += 1
        }

        return iterations < maxIterations ? currentDate : nil
    }

    /// Returns the previous business day from the given date.
    ///
    /// If the given date is already a business day, returns the previous business day before it.
    ///
    /// - Parameter date: The starting date
    /// - Returns: The previous business day, or nil if calculation fails
    public func previousBusinessDay(from date: Date) -> Date? {
        var currentDate = calendar.date(byAdding: .day, value: -1, to: date) ?? date

        // Safety limit to prevent infinite loops
        let maxIterations = 10
        var iterations = 0

        while !isBusinessDay(currentDate) && iterations < maxIterations {
            guard let prevDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                return nil
            }
            currentDate = prevDate
            iterations += 1
        }

        return iterations < maxIterations ? currentDate : nil
    }

    /// Returns the closest business day to the given date.
    ///
    /// If the date is already a business day, returns the same date.
    /// Otherwise, returns the next business day.
    ///
    /// - Parameter date: The date to find the closest business day for
    /// - Returns: The closest business day, or nil if calculation fails
    public func closestBusinessDay(to date: Date) -> Date? {
        if isBusinessDay(date) {
            return date
        }
        return nextBusinessDay(from: date)
    }

    // MARK: - Business Day Arithmetic

    /// Adds the specified number of business days to a date.
    ///
    /// This method skips weekends and holidays when counting business days.
    ///
    /// - Parameters:
    ///   - businessDays: The number of business days to add (can be negative)
    ///   - date: The starting date
    /// - Returns: The resulting date after adding business days, or nil if calculation fails
    ///
    /// ## Example
    /// ```swift
    /// let friday = // Some Friday
    /// let plus5BusinessDays = calculator.addBusinessDays(5, to: friday) // Returns the Friday of the following week
    /// ```
    public func addBusinessDays(_ businessDays: Int, to date: Date) -> Date? {
        if businessDays == 0 {
            return date
        }

        let direction = businessDays > 0 ? 1 : -1
        let absoluteDays = abs(businessDays)
        var currentDate = date
        var businessDaysAdded = 0

        // Safety limit to prevent infinite loops
        let maxIterations = absoluteDays * 3 // Assume worst case of 2 weekend days per business day
        var iterations = 0

        while businessDaysAdded < absoluteDays && iterations < maxIterations {
            guard let nextDate = calendar.date(byAdding: .day, value: direction, to: currentDate) else {
                return nil
            }
            currentDate = nextDate

            if isBusinessDay(currentDate) {
                businessDaysAdded += 1
            }

            iterations += 1
        }

        return iterations < maxIterations ? currentDate : nil
    }

    /// Subtracts the specified number of business days from a date.
    ///
    /// - Parameters:
    ///   - businessDays: The number of business days to subtract
    ///   - date: The starting date
    /// - Returns: The resulting date after subtracting business days, or nil if calculation fails
    public func subtractBusinessDays(_ businessDays: Int, from date: Date) -> Date? {
        return addBusinessDays(-businessDays, to: date)
    }

    // MARK: - Business Day Counting

    /// Counts the number of business days between two dates (inclusive).
    ///
    /// - Parameters:
    ///   - startDate: The start date
    ///   - endDate: The end date
    /// - Returns: The number of business days between the dates (including both endpoints if they are business days)
    ///
    /// ## Example
    /// ```swift
    /// let monday = // Some Monday
    /// let friday = // Friday of the same week
    /// let businessDays = calculator.businessDaysBetween(monday, and: friday) // Returns 5
    /// ```
    public func businessDaysBetween(_ startDate: Date, and endDate: Date) -> Int {
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)

        // Ensure start is before end
        let earlierDate = start <= end ? start : end
        let laterDate = start <= end ? end : start

        var businessDayCount = 0
        var currentDate = earlierDate

        while currentDate <= laterDate {
            if isBusinessDay(currentDate) {
                businessDayCount += 1
            }

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return businessDayCount
    }

    // MARK: - Holiday Management

    /// Creates a new BusinessDateCalculator with additional holidays.
    ///
    /// - Parameter additionalHolidays: Holidays to add to the existing holiday set
    /// - Returns: A new calculator with the combined holiday set
    public func addingHolidays(_ additionalHolidays: [Date]) -> BusinessDateCalculator {
        let combinedHolidays = holidays.union(Set(additionalHolidays.map { calendar.startOfDay(for: $0) }))
        return BusinessDateCalculator(calendar: calendar, holidays: combinedHolidays, weekendDays: weekendDays)
    }

    /// Creates a new BusinessDateCalculator with different weekend days.
    ///
    /// - Parameter weekendDays: The weekday numbers to treat as weekends (1=Sunday, 7=Saturday)
    /// - Returns: A new calculator with the specified weekend configuration
    ///
    /// ## Example
    /// ```swift
    /// // Create calculator for Middle Eastern countries (Friday-Saturday weekend)
    /// let calculator = BusinessDateCalculator().withWeekendDays([6, 7]) // Friday and Saturday
    /// ```
    public func withWeekendDays(_ weekendDays: Set<Int>) -> BusinessDateCalculator {
        return BusinessDateCalculator(calendar: calendar, holidays: holidays, weekendDays: weekendDays)
    }
}
