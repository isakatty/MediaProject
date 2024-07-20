//
//  SimilarMoviesResponse.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import Foundation

struct SimilarMoviesResponse: Decodable {
    let page: Int
    let results: [SimilarResponse]
    let total_pages: Int
    let total_results: Int
}
struct SimilarResponse: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}

extension SimilarMoviesResponse {
    var toDTO: SimilarMoviesDTO {
        return .init(
            page: page,
            results: results.compactMap({ similarMovie in
                guard let poster_path = similarMovie.poster_path else { return nil }
                return SimilarDTO(
                    id: similarMovie.id,
                    poster_path: poster_path
                )
            }),
            total_pages: total_pages,
            total_results: total_results
        )
    }
}
