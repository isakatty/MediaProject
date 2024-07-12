//
//  Constant.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

enum Constant {
    enum Font {
        static let bold23 = UIFont.boldSystemFont(ofSize: 23)
        static let bold21 = UIFont.boldSystemFont(ofSize: 21)
        static let bold19 = UIFont.boldSystemFont(ofSize: 19)
        static let bold17 = UIFont.boldSystemFont(ofSize: 17)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let light13 = UIFont.systemFont(
            ofSize: 13,
            weight: .light
        )
    }
    
    enum Spacing {
        case four
        case eight
        case twelve
        case sixteen
        
        var toCGFloat: CGFloat {
            switch self {
            case .four:
                4
            case .eight:
                8
            case .twelve:
                12
            case .sixteen:
                16
            }
        }
    }
}

