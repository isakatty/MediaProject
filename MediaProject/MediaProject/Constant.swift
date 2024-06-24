//
//  Constant.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

enum Constant {
    enum Endpoint {
        static let baseURL = "https://openapi.naver.com/v1/search/shop.json?"
    }
    
    enum Font {
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
}

