//
//  Trend.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import Foundation

struct TrendMovies: Decodable {
    let page: Int
    let results: [TrendInfo]
}

struct TrendInfo: Decodable {
    let poster_path: String?
}
