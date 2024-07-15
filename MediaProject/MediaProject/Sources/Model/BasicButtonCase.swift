//
//  BasicButtonCase.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/15/24.
//

import Foundation

enum BasicBtn: CaseIterable {
    case date, tag
    
    var toTitle: String {
        switch self {
        case .date:
            "영화 관람 날짜"
        case .tag:
            "태그"
        }
    }
}
