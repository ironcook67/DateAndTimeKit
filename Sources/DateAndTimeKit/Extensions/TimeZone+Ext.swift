//
//  TimeZone+Ext.swift
//  DateAndTimeKit
//
//  Created by Chon Torres on 6/18/25.
//

import Foundation

public extension TimeZone {
    /// UTC timezone convenience property
    static let utc = TimeZone(abbreviation: "UTC")!

    /// GMT timezone convenience property
    static let gmt = TimeZone(abbreviation: "GMT")!

    /// Eastern Standard Time convenience property
    static let est = TimeZone(abbreviation: "EST")!

    /// Pacific Standard Time convenience property
    static let pst = TimeZone(abbreviation: "PST")!
}
