//
//  Date+.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/20/24.
//

import UIKit

extension Date {
    var toString: String {
        DateChanger.format.dateFormat = DateChanger.yyyyMMdd.rawValue
        
        return DateChanger.format.string(from: self)
    }
}
