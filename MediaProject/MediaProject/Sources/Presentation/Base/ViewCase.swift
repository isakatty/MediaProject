//
//  ViewCase.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import Foundation

enum ViewCase {
    case trend
    case movieDetail(movie: String)
    case search
    case memo
    case calendar
    
    var viewTitle: String {
        switch self {
        case .trend:
            "트렌드"
        case .movieDetail(let movie):
            "\(movie)"
        case .search:
            "영화 검색"
        case .memo:
            "메모"
        case .calendar:
            "달력"
        }
    }
}
