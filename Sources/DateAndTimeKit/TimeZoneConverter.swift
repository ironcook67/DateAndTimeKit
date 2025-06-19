//
//  TimeZoneConverter.swift
//
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

/// A utility class for handling timezone conversions and date manipulations.
///
/// This class provides convenient methods for converting dates between timezones
/// and performing common date calculations using Foundation's Calendar APIs.
///
/// ## Key Concepts
///
/// ### Timezone Conversion Strategies
/// 1. **Absolute Time Preservation**: Maintains the same moment in time across timezones
/// 2. **Wall Clock Time Preservation**: Maintains the same displayed time across timezones
///
/// ### Example Usage
/// ```swift
/// let converter = TimeZoneConverter()
/// let utcDate = converter.convertToUTC(Date())
/// let localEquivalent = converter.convertUTCToLocal(utcDate)
/// ```
public struct TimeZoneConverter {
    
    /// The calendar instance used for date calculations
    private let calendar: Calendar
    
    /// Creates a new timezone converter with the current calendar
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    // MARK: - Timezone Conversion Methods
    
    /// Converts a date from one timezone to another while preserving the wall clock time.
    ///
    /// This method takes a date that represents a specific time in the source timezone
    /// and creates a new date that shows the same wall clock time in the target timezone.
    ///
    /// - Parameters:
    ///   - date: The source date
    ///   - targetTimeZone: The timezone to convert to
    /// - Returns: A new date with the same wall clock time in the target timezone
    ///
    /// ## Example
    /// ```swift
    /// // 2:30 PM EST becomes 2:30 PM PST (different moments in time)
    /// let estDate = // Some date at 2:30 PM EST
    /// let pstEquivalent = converter.convertWallClockTime(estDate, to: .pst)
    /// ```
    public func convertWallClockTime(_ date: Date, to targetTimeZone: TimeZone) -> Date? {
        var components = calendar.dateComponents(in: calendar.timeZone, from: date)
        components.timeZone = targetTimeZone
        return calendar.date(from: components)
    }
    
    /// Converts a date to represent the same moment in time in a different timezone.
    ///
    /// This method preserves the absolute moment in time while changing how it's
    /// interpreted in the target timezone.
    ///
    /// - Parameters:
    ///   - date: The source date
    ///   - sourceTimeZone: The timezone the date is currently in
    ///   - targetTimeZone: The timezone to convert to
    /// - Returns: A date representing the same moment in the target timezone
    ///
    /// ## Example
    /// ```swift
    /// // 2:30 PM EST becomes 11:30 AM PST (same moment in time)
    /// let estDate = // Some date at 2:30 PM EST
    /// let pstMoment = converter.convertAbsoluteTime(estDate, from: .est, to: .pst)
    /// ```
    public func convertAbsoluteTime(_ date: Date, from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date? {
        var components = calendar.dateComponents(in: sourceTimeZone, from: date)
        components.timeZone = targetTimeZone
        return calendar.date(from: components)
    }
    
    /// Converts a local date to UTC.
    ///
    /// This preserves the wall clock time - if it's 3:00 PM locally,
    /// this returns a date that represents 3:00 PM UTC.
    ///
    /// - Parameter localDate: The local date to convert
    /// - Returns: The equivalent UTC date, or nil if conversion fails
    public func convertToUTC(_ localDate: Date) -> Date? {
        return convertWallClockTime(localDate, to: TimeZone.utc)
    }
    
    /// Converts a UTC date to local time.
    ///
    /// This preserves the wall clock time - if it's 3:00 PM UTC,
    /// this returns a date that represents 3:00 PM in the local timezone.
    ///
    /// - Parameter utcDate: The UTC date to convert
    /// - Returns: The equivalent local date, or nil if conversion fails
    public func convertUTCToLocal(_ utcDate: Date) -> Date? {
        var components = calendar.dateComponents(in: .utc, from: utcDate)
        components.timeZone = calendar.timeZone
        return calendar.date(from: components)
    }
}
