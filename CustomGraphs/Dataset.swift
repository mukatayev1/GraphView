//
//  Dataset.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/18.
//

import Foundation

class Dataset {
    let weeklyData: [Int : [Int]] = [
        0 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        1 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        2 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        3 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        4 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        5 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        6 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)]
    ]
    
    let dailyData: [Int : [Int]] = [
         0 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         1 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         2 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         3 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         4 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         5 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         6 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         7 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         8 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
         9 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        10 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        11 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        12 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        13 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        14 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        15 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        16 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        17 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        18 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        19 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        20 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        21 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        22 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)],
        23 : [Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500), Int.random(in: 0...500)]
    ]
    
    func monthlyData(date: Date) -> [Int : [Int]] {
        let components = Calendar.current.dateComponents([.year,.month], from: date)
        var data: [Int : [Int]] = [:]
        
        for i in 0..<getNumberOfDays(year: components.year!, month: components.month!) {
            data[i] = [Int.random(in: 0...500), Int.random(in: 0...500)]
        }
        return data
    }
    
    private func getDateDays(year: Int, month: Int, weekday: MonthWeekDateManager.Weekday) {
        
        let components = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else { return }
        
        let dates = MonthWeekDateManager.getDatesForEvery(weekday: weekday, date: date)
        print(dates)
    }
    
    private func getNumberOfDays(year: Int? = nil, month: Int? = nil) -> Int {
        var date = Date()
        if let year = year, let month = month {
            let calendar = Calendar.current
            let components = DateComponents(year: year, month: month)
            date = calendar.date(from: components)!
        }
        let numberOfDays = MonthWeekDateManager.calculateDaysPerMonth(date: date)
        return numberOfDays
    }
}
