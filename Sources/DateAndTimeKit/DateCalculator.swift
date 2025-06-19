//
//  DateCalculator.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

/// A utility for performing date arithmetic and manipulations.
///
/// This struct provides convenient methods for common date operations like
/// adding/subtracting time intervals, finding start/end of periods, and
/// calculating differences between dates.
public struct DateCalculator {
    
    /// The calendar instance used for calculations
    private let calendar: Calendar
    
    /// Creates a new date calculator with the specified calendar
    /// - Parameter calendar: The calendar to use for calculations (defaults to current)
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    // MARK: - Date Arithmetic
    
    /// Adds the specified time components to a date.
    ///
    /// - Parameters:
    ///   - date: The base date
    ///   - days: Number of days to add (can be negative)
    ///   - hours: Number of hours to add (can be negative)
    ///   - minutes: Number of minutes to add (can be negative)
    ///   - seconds: Number of seconds to add (can be negative)
    /// - Returns: The new date with the time added, or the original date if calculation fails
    public func add(to date: Date, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var components = DateComponents()
        components.day = days
        components.hour = hours
        components.minute = minutes
        components.second = seconds
        
        return calendar.date(byAdding: components, to: date) ?? date
    }
    
    /// Subtracts the specified time components from a date.
    ///
    /// - Parameters:
    ///   - date: The base date
    ///   - days: Number of days to subtract
    ///   - hours: Number of hours to subtract
    ///   - minutes: Number of minutes to subtract
    ///   - seconds: Number of seconds to subtract
    /// - Returns: The new date with the time subtracted, or the original date if calculation fails
    public func subtract(from date: Date, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        return add(to: date, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    // MARK: - Period Boundaries
    
    /// Returns the start of the day for the given date.
    /// - Parameter date: The date to find the start of day for
    /// - Returns: A date representing midnight of the given date
    public func startOfDay(for date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }
    
    /// Returns the end of the day for the given date.
    /// - Parameter date: The date to find the end of day for
    /// - Returns: A date representing 23:59:59 of the given date
    public func endOfDay(for date: Date) -> Date {
        let startOfNextDay = add(to: startOfDay(for: date), days: 1)
        return subtract(from: startOfNextDay, seconds: 1)
    }
    
    /// Returns the start of the hour for the given date.
    /// - Parameter date: The date to find the start of hour for
    /// - Returns: A date with minutes and seconds set to zero
    public func startOfHour(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        return calendar.date(from: components) ?? date
    }
    
    // MARK: - Date Comparisons and Calculations
    
    /// Calculates the number of days between two dates (inclusive of endpoints).
    ///
    /// - Parameters:
    ///   - startDate: The starting date
    ///   - endDate: The ending date
    /// - Returns: The number of days between the dates, including both endpoints
    ///
    /// ## Example
    /// ```swift
    /// // From Jan 1 to Jan 3 = 3 days (Jan 1, Jan 2, Jan 3)
    /// let days = calculator.daysBetween(jan1, and: jan3) // Returns 3
    /// ```
    public func daysBetween(_ startDate: Date, and endDate: Date) -> Int {
        let start = startOfDay(for: startDate)
        let end = startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return abs(components.day ?? 0) + 1 // +1 to include both endpoints
    }
    
    /// Checks if two dates are on the same day.
    /// - Parameters:
    ///   - date1: First date to compare
    ///   - date2: Second date to compare
    /// - Returns: true if both dates are on the same calendar day
    public func areSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// Calculates the time interval between two dates.
    /// - Parameters:
    ///   - startDate: The starting date
    ///   - endDate: The ending date
    /// - Returns: The time interval in seconds (negative if startDate is after endDate)
    public func timeInterval(from startDate: Date, to endDate: Date) -> TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
}
