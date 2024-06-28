//
//  Movie.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let rank, movieNm, openDt: String
}
