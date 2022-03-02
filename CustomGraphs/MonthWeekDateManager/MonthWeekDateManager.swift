//
//  MonthWeekDateManager.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/18.
//

import Foundation

struct MonthWeekDateManager {
    
    static func calculateDaysPerMonth(date: Date = Date()) -> Int {
        let userCalendar = Calendar.current
        let numberOfDays = userCalendar.range(of: .day, in: .month, for: date)!.count
        return numberOfDays
    }

    static private func getFirstWeekdayOfMonth(date: Date, weekday: Weekday) -> Int {
        let userCalendar = Calendar.current
        //Get required year and month numbers
        let dateComponents: DateComponents = userCalendar.dateComponents([.year, .month], from: date)
        //Get date components of the first monday for the given year and month
        let components = DateComponents(year: dateComponents.year!, month: dateComponents.month!, weekday: weekday.rawValue, weekdayOrdinal: 1)
        //Get date for the calculated components
        let convertedDate = userCalendar.date(from: components)
        //Finally, get the day number of the first monday
        let firstMondayDay = userCalendar.dateComponents([.day], from: convertedDate!).day
        
        return firstMondayDay!
    }

    static private func getArrayOfWeekdayDates(numberOfDays: Int, firstDayOfWeekday: Int) -> [Int] {
        var tempArray: [Int] = []
        var i = firstDayOfWeekday
        while i <= numberOfDays {
            tempArray.append(i)
            i += 7
        }
        return tempArray
    }

    static func getDatesForEvery(weekday: Weekday, date: Date = Date()) -> [Int] {
        let numberOfDays: Int = calculateDaysPerMonth(date: date)
        let firstDayOfWeekday = getFirstWeekdayOfMonth(date: date, weekday: weekday)
        let weekdayDates = getArrayOfWeekdayDates(numberOfDays: numberOfDays, firstDayOfWeekday: firstDayOfWeekday)
        return weekdayDates
    }
}

extension MonthWeekDateManager {
    enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
}
