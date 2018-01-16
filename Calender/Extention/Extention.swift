//
//  Extention.swift
//  Calender
//
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func toMonthString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let monthStr = formatter.string(from: self)
        return monthStr
    }
    
    func toDayString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dayStr = formatter.string(from: self)
        return dayStr
    }
    
    func toString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dayStr = formatter.string(from: self)
        return dayStr
    }
    
    
}