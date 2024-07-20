//
//  DateChanger.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import UIKit

enum DateChanger: String {
    static let format = DateFormatter()
    
    case yyyyMMdd = "yyyy-MM-dd"
    
    func isSameDate(date1: Date, date2: Date) -> Bool {
        DateChanger.format.dateFormat = DateChanger.yyyyMMdd.rawValue
        let dateString1 = DateChanger.format.string(from: date1)
        let dateString2 = DateChanger.format.string(from: date2)
        return dateString1 == dateString2
    }
}
