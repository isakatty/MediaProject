//
//  DateFormatterManager.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import UIKit

// 날짜 formatter 필요함
final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private let customDateFormatter: DateFormatter
    
    private init() {
        customDateFormatter = DateFormatter()
        customDateFormatter.locale = Locale(identifier: "ko_KR")
        customDateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func isSameDate(date1: Date, date2: Date) -> Bool {
        let dateString1 = customDateFormatter.string(from: date1)
        let dateString2 = customDateFormatter.string(from: date2)
        return dateString1 == dateString2
    }
    func changedDateFormat(date1: Date) -> String {
        
        let dateString1 = customDateFormatter.string(from: date1)
        
        return dateString1
    }
}
