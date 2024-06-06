//
//  Movie.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let rank, movieNm, openDt: String
}
