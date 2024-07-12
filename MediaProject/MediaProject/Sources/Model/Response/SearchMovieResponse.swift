//
//  SearchMovieResponse.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct SearchMovieResponse: Decodable {
    var page: Int
    var results: [SearchedMovieInfoResponse]
    let total_pages, total_results: Int
}

struct SearchedMovieInfoResponse: Decodable {
    let adult: Bool
    let backdrop_path, poster_path: String?
    let original_language, original_title, overview, title: String
    let id: Int
    let genre_ids: [Int]
    let vote_average: Double
    let vote_count: Int
    let video: Bool
    let release_date: String
}

extension SearchMovieResponse {
    var toDTO: SearchResponseDTO {
        return .init(
            page: page,
            results: results.compactMap {
                guard let profile_path = $0.poster_path,
                      let backdrop_path = $0.backdrop_path else { return nil }
                return SearchMovieResponseDTO(
                    backdrop_path: backdrop_path,
                    poster_path: profile_path,
                    overview: $0.overview,
                    title: $0.title,
                    id: $0.id,
                    vote_average: $0.vote_average,
                    vote_count: $0.vote_count,
                    release_date: $0.release_date
                )
            },
            total_pages: total_pages,
            total_results: total_results
        )
    }
}
