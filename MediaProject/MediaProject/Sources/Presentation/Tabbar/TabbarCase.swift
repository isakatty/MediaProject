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
    
    var tabBarName: String {
        switch self {
        case .search:
            "검색"
        case .trend:
            "트렌드"
        }
    }
    var nomalIconName: String {
        switch self {
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper"
        }
    }
    var tintedIconName: String {
        switch self {
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper.fill"
        }
    }
}
