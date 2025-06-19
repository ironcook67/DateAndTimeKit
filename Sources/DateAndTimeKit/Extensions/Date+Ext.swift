//
//  Date+Ext.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

public extension Date {
    /// Start of the current hour
    static var startOfCurrentHour: Date {
        DateCalculator().startOfHour(for: .now)
    }

    /// Start of today
    static var startOfToday: Date {
        DateCalculator().startOfDay(for: .now)
    }

    /// End of today
    static var endOfToday: Date {
        DateCalculator().endOfDay(for: .now)
    }

    /// Yesterday at the same time
    static var dayEarlierSameTime: Date {
        DateCalculator().subtract(from: .now, days: 1)
    }

    /// Start of yesterday
    static var startOfYesterday: Date {
        DateCalculator().startOfDay(for: dayEarlierSameTime)
    }

    /// Start of tomorrow
    static var startOfTomorrow: Date {
        DateCalculator().add(to: startOfToday, days: 1)
    }
}

