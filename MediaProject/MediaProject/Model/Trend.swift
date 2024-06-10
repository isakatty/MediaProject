//
//  Trend.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import Foundation

public struct Trend: Decodable {
    let page: Int
    let results: [MovieInfo]
}

public struct MovieInfo: Decodable {
    let backdrop_path: String
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let media_type: String
    let adult: Bool
    let title: String
    let original_language: String
    let release_date: String
    let vote_average: Double
    let vote_count: Int
}
