# DateAndTimeKit

A comprehensive Swift Package for common date, time, timezone, and calendar operations. Designed to make working with dates in Swift more intuitive and less error-prone.

## Features

### 📅 Date Calculations
- **DateCalculator**: Robust date arithmetic with proper calendar handling
- **Date Extensions**: Convenient properties for common date operations
- **Business Day Calculator**: Handle weekends, holidays, and business day arithmetic

### 🌍 Timezone Management
- **TimeZone Extensions**: Quick access to common timezones (UTC, GMT, EST, PST)
- **TimeZoneConverter**: Convert between timezones with wall-clock or absolute time preservation
- **Proper DST Handling**: Accounts for daylight saving time transitions

### 📄 Date Formatting
- **StandardDateFormatters**: Pre-configured formatters for ISO 8601 and common formats
- **Timezone-Aware Formatting**: Consistent formatting across different timezones
- **Parsing and Round-Trip Safety**: Reliable date string parsing with error handling

### 📆 Calendar Utilities
- **Calendar Extensions**: Enhanced calendar operations and calculations
- **Period Boundaries**: Find start/end of day, week, month, year
- **Leap Year Support**: Proper handling of leap years and month boundaries

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/DateAndTimeKit.git", from: "0.9.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Choose your version requirements

## Quick Start

```swift
import DateAndTimeKit

// Date calculations
let calculator = DateCalculator()
let nextWeek = calculator.add(to: Date(), days: 7)
let daysBetween = calculator.daysBetween(startDate, and: endDate)

// Convenient date properties
let startOfToday = Date.startOfToday
let endOfToday = Date.endOfToday
let yesterday = Date.startOfYesterday

// Business day calculations
let businessCalculator = BusinessDateCalculator()
let nextBusinessDay = businessCalculator.nextBusinessDay(from: Date())
let businessDaysCount = businessCalculator.businessDaysBetween(start, and: end)

// Timezone conversions
let converter = TimeZoneConverter()
let utcDate = converter.convertToUTC(localDate)
let pstTime = converter.convertWallClockTime(date, to: .pst)

// Date formatting
let dateString = StandardDateFormatters.utcDateString(from: Date())
let parsedDate = StandardDateFormatters.utcDate(from: "2024-03-15")

// Calendar operations
let daysInMonth = Calendar.gregorian.daysInMonth(2, year: 2024) // 29 (leap year)
let isLeapYear = Calendar.gregorian.isLeapYear(2024) // true
let startOfMonth = Calendar.current.startOfMonth(for: Date())
```

## Detailed Usage

### DateCalculator

The `DateCalculator` provides reliable date arithmetic that properly handles calendar boundaries, leap years, and timezone transitions.

```swift
let calculator = DateCalculator()

// Add time components
let futureDate = calculator.add(to: Date(), days: 5, hours: 3, minutes: 30)

// Subtract time components  
let pastDate = calculator.subtract(from: Date(), days: 10, hours: 2)

// Find period boundaries
let startOfDay = calculator.startOfDay(for: someDate)
let endOfDay = calculator.endOfDay(for: someDate)
let startOfHour = calculator.startOfHour(for: someDate)

// Date comparisons
let dayCount = calculator.daysBetween(startDate, and: endDate)
let isSameDay = calculator.areSameDay(date1, date2)
let timeInterval = calculator.timeInterval(from: startDate, to: endDate)
```

### BusinessDateCalculator

Handle business days, weekends, and holidays with ease.

```swift
// Basic business day calculator (excludes weekends)
let calculator = BusinessDateCalculator()

// Check if a date is a business day
let isBusinessDay = calculator.isBusinessDay(someDate)

// Navigate business days
let nextBusinessDay = calculator.nextBusinessDay(from: Date())
let previousBusinessDay = calculator.previousBusinessDay(from: Date())

// Business day arithmetic
let futureBusinessDate = calculator.addBusinessDays(5, to: Date())
let businessDayCount = calculator.businessDaysBetween(startDate, and: endDate)

// Add holidays
let holidays = [
    DateComponents(year: 2024, month: 7, day: 4), // July 4th
    DateComponents(year: 2024, month: 12, day: 25) // Christmas
].compactMap { Calendar.current.date(from: $0) }

let calculatorWithHolidays = calculator.addingHolidays(holidays)

// Different weekend configurations (e.g., Middle East: Friday-Saturday)
let fridaySaturdayWeekend = calculator.withWeekendDays([6, 7])
```

### TimeZone Management

Easy access to common timezones and reliable conversion methods.

```swift
// Convenient timezone access
let utc = TimeZone.utc
let eastern = TimeZone.est  
let pacific = TimeZone.pst
let gmt = TimeZone.gmt

// Timezone conversion
let converter = TimeZoneConverter()

// Preserve wall clock time (3 PM EST becomes 3 PM PST)
let wallClockConverted = converter.convertWallClockTime(date, to: .pst)

// Preserve absolute time (3 PM EST becomes 12 PM PST)  
let absoluteConverted = converter.convertAbsoluteTime(date, from: .est, to: .pst)

// UTC conversions
let utcDate = converter.convertToUTC(localDate)
let localDate = converter.convertUTCToLocal(utcDate)
```

### Date Formatting

Consistent, timezone-aware date formatting with proper ISO 8601 support.

```swift
// Pre-configured formatters
let utcFormatter = StandardDateFormatters.iso8601Date
let localFormatter = StandardDateFormatters.iso8601DateLocal
let dateTimeFormatter = StandardDateFormatters.iso8601DateTime

// Convenience methods
let dateString = StandardDateFormatters.utcDateString(from: Date())
let localString = StandardDateFormatters.localDateString(from: Date())

// Parsing
let parsedDate = StandardDateFormatters.utcDate(from: "2024-03-15")
let localParsedDate = StandardDateFormatters.localDate(from: "2024-03-15")
```

### Calendar Extensions

Enhanced calendar operations for common date calculations.

```swift
// Calendar convenience properties
let gregorian = Calendar.gregorian
let iso8601 = Calendar.iso8601

// Month and year queries
let daysInFebruary2024 = Calendar.gregorian.daysInMonth(2, year: 2024) // 29
let isLeapYear = Calendar.gregorian.isLeapYear(2024) // true

// Period boundaries
let startOfWeek = Calendar.current.startOfWeek(for: Date())
let endOfWeek = Calendar.current.endOfWeek(for: Date())
let startOfMonth = Calendar.current.startOfMonth(for: Date())
let endOfMonth = Calendar.current.endOfMonth(for: Date())
let startOfYear = Calendar.current.startOfYear(for: Date())
let endOfYear = Calendar.current.endOfYear(for: Date())
```

### Date Extensions

Convenient properties for common date operations.

```swift
// Current time-based properties
let startOfCurrentHour = Date.startOfCurrentHour
let startOfToday = Date.startOfToday
let endOfToday = Date.endOfToday

// Relative dates
let yesterdaySameTime = Date.dayEarlierSameTime
let startOfYesterday = Date.startOfYesterday  
let startOfTomorrow = Date.startOfTomorrow
```

## Architecture

DateAndTimeKit follows these design principles:

- **Immutability**: All operations return new date instances rather than modifying existing ones
- **Calendar Awareness**: Proper handling of different calendar systems and locales
- **Timezone Safety**: Explicit timezone handling to prevent common pitfalls
- **Error Resilience**: Graceful handling of edge cases and invalid inputs
- **Performance**: Efficient algorithms with safety limits for complex operations
- **Documentation**: Comprehensive DocC documentation with examples

## Testing

The package includes comprehensive test coverage:

- **Unit Tests**: Over 200 unit tests covering all functionality
- **Edge Cases**: Leap years, month boundaries, timezone transitions, DST changes
- **Performance Tests**: Ensuring operations perform well under load
- **Integration Tests**: Verifying components work together correctly

Run tests with:

```bash
swift test
```

## Requirements

- **iOS**: 13.0+
- **macOS**: 10.15+
- **tvOS**: 13.0+
- **watchOS**: 6.0+
- **Swift**: 5.7+

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Update documentation
6. Submit a pull request

## Documentation

Full API documentation is available through DocC. Build and view documentation with:

```bash
swift package generate-documentation --target DateAndTimeKit
```

## Common Use Cases

### Project Planning
```swift
let projectStart = Date()
let calculator = BusinessDateCalculator()

// Add 30 business days for project duration
let projectEnd = calculator.addBusinessDays(30, to: projectStart)

// How many business days until deadline?
let daysRemaining = calculator.businessDaysBetween(Date(), and: projectEnd)
```

### Financial Applications
```swift
// Calculate settlement date (T+2 business days)
let tradeDate = Date()
let businessCalc = BusinessDateCalculator()
let settlementDate = businessCalc.addBusinessDays(2, to: tradeDate)

// Check if market is open
let isMarketDay = businessCalc.isBusinessDay(Date())
```

### Scheduling Systems
```swift
// Find next available appointment slot
let scheduler = BusinessDateCalculator()
let nextSlot = scheduler.nextBusinessDay(from: Date())

// Schedule recurring weekly meetings
let dateCalc = DateCalculator()
var meetingDates: [Date] = []
var currentDate = Date.startOfToday

for _ in 0..<10 {
    meetingDates.append(currentDate)
    currentDate = dateCalc.add(to: currentDate, days: 7)
}
```

### International Applications
```swift
// Handle different weekend patterns
let middleEastCalc = BusinessDateCalculator()
    .withWeekendDays([6, 7]) // Friday-Saturday weekend

// Multi-timezone scheduling
let converter = TimeZoneConverter()
let utcMeeting = converter.convertToUTC(localMeetingTime)
let tokyoTime = converter.convertWallClockTime(utcMeeting, to: TimeZone(identifier: "Asia/Tokyo")!)
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with Swift's robust Foundation date and calendar APIs
- Inspired by common date manipulation challenges in iOS/macOS development
- Designed for clarity and safety in date operations
