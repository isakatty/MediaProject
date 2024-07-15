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
    
    var groupSize: [String: CGFloat] {
        switch self {
        case .movieInfo:
            return ["wid": 1.0, "hght": 0.5]
        case .cast:
            return ["wid": 2 / 9, "hght": 0.2]
        case .poster:
            return ["wid": 1 / 3 , "hght": 0.13]
        case .similar:
            return ["wid": 1 / 4 , "hght": 0.25]
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
