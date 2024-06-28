//
//  TabbarCase.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import Foundation

enum TabbarCase: Int, CaseIterable {
    case home = 0
    case search
    case trend
    
    var tabBarName: String {
        switch self {
        case .home:
            "홈"
        case .search:
            "검색"
        case .trend:
            "트렌드"
        }
    }
    var nomalIconName: String {
        switch self {
        case .home:
            "house"
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper"
        }
    }
    var tintedIconName: String {
        switch self {
        case .home:
            "house.fill"
        case .search:
            "magnifyingglass"
        case .trend:
            "movieclapper.fill"
        }
    }
}
