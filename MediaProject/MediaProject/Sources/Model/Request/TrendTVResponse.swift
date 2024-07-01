//
//  TrendTVResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct TrendTVResponse: Decodable {
    let page: Int
    let results: [TVInfoResponse]
}

struct TVInfoResponse: Decodable {
    let backdrop_path: String
    let id: Int
    let name: String
    let original_name: String
    let overview: String
    let poster_path: String
    let media_type: String
    let adult: Bool
    let original_language: String
    let genre_ids: [Int]
    let popularity: Double
    let first_air_date: String
    let vote_average: Double
    let vote_count: Int
    let origin_country: [String]
}

extension TrendTVResponse {
    var toDTO: TrendTVResponseDTO {
        return .init(page: page,
                     media: results.map {
            TVResponseDTO(
                id: $0.id,
                name: $0.name,
                poster_path: $0.poster_path
            )
        })
    }
}
