//
//  Date + Extension.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 28.01.2022.
//
//
import Foundation

extension Date {

    func localDate() -> Date {
        let timeZoneOffSet = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffSet), to: self) ?? Date()
        return localDate
    }

    func getWeekDayNumber() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }

    func starAndDate() -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)

        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date()
        let dateEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart) ?? Date()
        }()
        
        return (dateStart, dateEnd)
    }

    func offsetDays(days: Int) -> Date {
        let offsetDate = Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
        return offsetDate
    }
    
    func offsetMonth(month: Int) -> Date {
        let offsetDate = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offsetDate
    }
    
    func getWeekArray() -> [[String]] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "EEEEEE"
        
        var weekArray: [[String]] = [[], []]
        let calendar = Calendar.current
        
        for index in -6...0{
            let date = calendar.date(byAdding: .weekday, value: index, to: self) ?? Date()
            let day = calendar.component(.day, from: date)
            weekArray[1].append("\(day)")
            let weekday = formatter.string(from: date)
            weekArray[0].append(weekday)
        }
        return weekArray
    }
    
    func ddMMyyyyFromDate() -> String {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: self)
        return date
    }
}
