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
    
    static let widthValues: [TrendDetailSectionKind: CGFloat] = [
        .movieInfo: 1.0,
        .cast: 2 / 9,
        .poster: 1 / 3,
        .similar: 1 / 4
    ]
    
    static let heightValues: [TrendDetailSectionKind: CGFloat] = [
        .movieInfo: 0.5,
        .cast: 0.2,
        .poster: 0.13,
        .similar: 0.25
    ]
    
    var width: CGFloat {
        return Self.widthValues[self] ?? 0
    }
    
    var height: CGFloat {
        return Self.heightValues[self] ?? 0
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
