//
//  TrendDetailSectionKind.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/15/24.
//

import Foundation

enum TrendDetailSectionKind: Int, CaseIterable {
    case movieInfo = 0
    case cast
    case poster
    case similar
    
    var width: CGFloat {
        switch self {
        case .movieInfo: return 1.0
        case .cast: return 2 / 9
        case .poster: return 1 / 3
        case .similar: return 1 / 4
        }
    }
        
    var height: CGFloat {
        switch self {
        case .movieInfo: return 0.5
        case .cast: return 0.2
        case .poster: return 0.13
        case .similar: return 0.25
        }
    }
    
    var toTitle: String {
        switch self {
        case .movieInfo:
            ""
        case .cast:
            "출연 배우"
        case .poster:
            "영화 포스터"
        case .similar:
            "비슷한 영화"
        }
    }
}
