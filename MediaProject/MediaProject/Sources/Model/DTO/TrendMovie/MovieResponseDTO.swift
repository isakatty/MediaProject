//
//  MovieResponse.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import Foundation

struct MovieResponseDTO: Hashable {
    let id: Int
    let title: String
    let poster_path: String
    let backdrop_path: String
    let releaseDate: String
    let overView: String
    let voteAvg: Double
    let voteCnt: Int
}
