//
//  MovieDetailResponse.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/21/24.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let belongs_to_collection: BelongCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdb_id: String
    let origin_country: [String]
    let original_language: String
    let original_title: String
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let production_companies: [ProductionCompany]
    let production_countries: [ProductionCountry]
    let release_date: String
    let revenue: Int
    let runtime: Int
    let spoken_languages: [Languages]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}

extension MovieDetailResponse {
    var toDTO: MovieResponseDTO {
        return .init(
            id: id,
            title: title,
            poster_path: poster_path ?? "",
            backdrop_path: backdrop_path ?? "",
            releaseDate: release_date,
            overView: overview ?? "",
            voteAvg: vote_average,
            voteCnt: vote_count
        )
    }
}

struct BelongCollection: Decodable {
    let id: Int
    let name: String
    let poster_path: String?
    let backdrop_path: String?
}
struct Genre: Decodable {
    let id: Int
    let name: String
}
struct ProductionCompany: Decodable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}
struct ProductionCountry: Decodable {
    let iso_3166_1: String
    let name: String
}

struct Languages: Decodable {
    let english_name: String
    let iso_639_1: String
    let name: String
}
