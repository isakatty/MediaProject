//
//  TableViewSection.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import Foundation

enum TableViewSection: Int, CaseIterable {
    case similar
    case recommend
    case poster
    
    var title: String {
        switch self {
        case .similar: return "비슷한 영화"
        case .recommend: return "추천 영화"
        case .poster: return "포스터"
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case .similar, .recommend:
            return 220
        case .poster:
            return 260
        }
    }
}
