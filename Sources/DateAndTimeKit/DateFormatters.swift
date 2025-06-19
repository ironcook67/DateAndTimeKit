//
//  DateFormatters.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation
/// A collection of commonly used date formatters with proper timezone handling.
///
/// This struct provides pre-configured formatters for various date representations,
/// with special attention to timezone handling for consistent formatting across
/// different locales and timezones.
public struct StandardDateFormatters {

    // MARK: - ISO 8601 Formatters

    /// ISO 8601 date formatter for UTC dates (yyyy-MM-dd format).
    ///
    /// This formatter is ideal for:
    /// - API communication
    /// - Date storage
    /// - Cross-timezone date representation
    ///
    /// Example output: "2024-03-15"
    public static let iso8601Date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.utc
        return formatter
    }()

    /// ISO 8601 date formatter for local timezone dates (yyyy-MM-dd format).
    ///
    /// Same format as iso8601Date but uses the local timezone.
    /// Useful for displaying dates in the user's local context.
    ///
    /// Example output: "2024-03-15"
    public static let iso8601DateLocal: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    /// ISO 8601 datetime formatter for UTC (yyyy-MM-dd HH:mm format).
    ///
    /// Includes both date and time components in UTC.
    /// Perfect for timestamps that need timezone consistency.
    ///
    /// Example output: "2024-03-15 14:30"
    public static let iso8601DateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.utc
        return formatter
    }()

    /// ISO 8601 datetime formatter for local timezone (yyyy-MM-dd HH:mm format).
    ///
    /// Same as iso8601DateTime but displays in the user's local timezone.
    ///
    /// Example output: "2024-03-15 14:30"
    public static let iso8601DateTimeLocal: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    // MARK: - Convenience Methods

    /// Formats a date as an ISO 8601 date string in UTC.
    /// - Parameter date: The date to format
    /// - Returns: A string in "yyyy-MM-dd" format
    public static func utcDateString(from date: Date) -> String {
        return iso8601Date.string(from: date)
    }

    /// Formats a date as an ISO 8601 date string in local timezone.
    /// - Parameter date: The date to format
    /// - Returns: A string in "yyyy-MM-dd" format
    public static func localDateString(from date: Date) -> String {
        return iso8601DateLocal.string(from: date)
    }

    /// Parses an ISO 8601 date string as a UTC date.
    /// - Parameter dateString: The date string to parse (format: "yyyy-MM-dd")
    /// - Returns: The parsed date, or nil if parsing fails
    public static func utcDate(from dateString: String) -> Date? {
        return iso8601Date.date(from: dateString)
    }

    /// Parses an ISO 8601 date string as a local date.
    /// - Parameter dateString: The date string to parse (format: "yyyy-MM-dd")
    /// - Returns: The parsed date, or nil if parsing fails
    public static func localDate(from dateString: String) -> Date? {
        return iso8601DateLocal.date(from: dateString)
    }
}
