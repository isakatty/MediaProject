//
//  SearchMovieResponseDTO.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

struct SearchMovieResponseDTO: Decodable {
    let backdrop_path, poster_path: String
    let overview, title: String
    let id: Int
    let vote_average: Double
    let vote_count: Int
    let release_date: String
}
