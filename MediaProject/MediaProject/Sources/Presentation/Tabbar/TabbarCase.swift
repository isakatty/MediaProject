//
//  TabbarCase.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import Foundation

enum TabbarCase: Int, CaseIterable {
    case trend = 0
    case search
    case memo
    
    var tabBarName: String {
        switch self {
        case .search:
            "검색"
        case .trend:
            "트렌드"
        case .memo:
            "영화 기록"
        }
    }
    var nomalIconName: String {
        switch self {
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper"
        case .memo:
            "doc.text"
        }
    }
    var tintedIconName: String {
        switch self {
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper.fill"
        case .memo:
            "doc.text.fill"
        }
    }
}
