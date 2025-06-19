//
//  Calendar+Ext.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

public extension Calendar {
    /// Common calendar convenience properties for easier access to frequently used calendars.

    /// Gregorian calendar convenience property
    static let gregorian = Calendar(identifier: .gregorian)

    /// ISO 8601 calendar convenience property
    static let iso8601 = Calendar(identifier: .iso8601)

    /// Buddhist calendar convenience property
    static let buddhist = Calendar(identifier: .buddhist)

    /// Hebrew calendar convenience property
    static let hebrew = Calendar(identifier: .hebrew)

    /// Islamic calendar convenience property
    static let islamic = Calendar(identifier: .islamic)

    // MARK: - Date Range Methods

    /// Returns the number of days in the specified month and year.
    ///
    /// - Parameters:
    ///   - month: The month (1-12)
    ///   - year: The year
    /// - Returns: The number of days in the month, or nil if invalid month/year
    ///
    /// ## Example
    /// ```swift
    /// let daysInFeb2024 = Calendar.current.daysInMonth(2, year: 2024) // Returns 29 (leap year)
    /// let daysInFeb2023 = Calendar.current.daysInMonth(2, year: 2023) // Returns 28
    /// ```
    func daysInMonth(_ month: Int, year: Int) -> Int? {
        guard month >= 1 && month <= 12 else { return nil }

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let date = self.date(from: components),
              let range = self.range(of: .day, in: .month, for: date) else {
            return nil
        }

        return range.count
    }

    /// Returns whether the specified year is a leap year in this calendar.
    ///
    /// - Parameter year: The year to check
    /// - Returns: true if the year is a leap year, false otherwise
    ///
    /// ## Example
    /// ```swift
    /// let isLeap2024 = Calendar.gregorian.isLeapYear(2024) // Returns true
    /// let isLeap2023 = Calendar.gregorian.isLeapYear(2023) // Returns false
    /// ```
    func isLeapYear(_ year: Int) -> Bool {
        // February has 29 days in a leap year, 28 in a regular year
        return daysInMonth(2, year: year) == 29
    }

    // MARK: - Week Calculations

    /// Returns the start of the week for the given date.
    ///
    /// - Parameter date: The date to find the start of week for
    /// - Returns: A date representing the first day of the week containing the given date
    ///
    /// ## Example
    /// ```swift
    /// let someWednesday = // Some Wednesday date
    /// let startOfWeek = Calendar.current.startOfWeek(for: someWednesday) // Returns the preceding Sunday (or Monday, depending on calendar settings)
    /// ```
    func startOfWeek(for date: Date) -> Date? {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)
    }

    /// Returns the end of the week for the given date.
    ///
    /// - Parameter date: The date to find the end of week for
    /// - Returns: A date representing the last moment of the last day of the week containing the given date
    func endOfWeek(for date: Date) -> Date? {
        guard let startOfWeek = startOfWeek(for: date),
              let endOfWeek = self.date(byAdding: .weekOfYear, value: 1, to: startOfWeek),
              let endOfWeekMinusOneSecond = self.date(byAdding: .second, value: -1, to: endOfWeek) else {
            return nil
        }
        return endOfWeekMinusOneSecond
    }

    // MARK: - Month Calculations

    /// Returns the start of the month for the given date.
    ///
    /// - Parameter date: The date to find the start of month for
    /// - Returns: A date representing the first day of the month containing the given date
    func startOfMonth(for date: Date) -> Date? {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)
    }

    /// Returns the end of the month for the given date.
    ///
    /// - Parameter date: The date to find the end of month for
    /// - Returns: A date representing the last moment of the last day of the month containing the given date
    func endOfMonth(for date: Date) -> Date? {
        guard let startOfMonth = startOfMonth(for: date),
              let endOfMonth = self.date(byAdding: DateComponents(month: 1, second: -1), to: startOfMonth) else {
            return nil
        }
        return endOfMonth
    }

    // MARK: - Year Calculations

    /// Returns the start of the year for the given date.
    ///
    /// - Parameter date: The date to find the start of year for
    /// - Returns: A date representing the first day of the year containing the given date
    func startOfYear(for date: Date) -> Date? {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)
    }

    /// Returns the end of the year for the given date.
    ///
    /// - Parameter date: The date to find the end of year for
    /// - Returns: A date representing the last moment of the last day of the year containing the given date
    func endOfYear(for date: Date) -> Date? {
        guard let startOfYear = startOfYear(for: date),
              let endOfYear = self.date(byAdding: DateComponents(year: 1, second: -1), to: startOfYear) else {
            return nil
        }
        return endOfYear
    }
}
