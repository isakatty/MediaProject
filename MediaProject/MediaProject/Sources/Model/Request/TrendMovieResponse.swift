//
//  TrendMovieResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct TrendMovieResponse: Decodable {
    let page: Int
    let results: [MovieInfoResponse]
}

struct MovieInfoResponse: Decodable {
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

extension TrendMovieResponse {
    var toDomain: TrendMovieResponseDTO {
        return .init(page: page,
                     media: results.map {
            MovieResponseDTO(
                id: $0.id,
                title: $0.title,
                poster_path: $0.poster_path
            )
        })
    }
}
