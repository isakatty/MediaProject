//
//  SearchedMovie.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/12/24.
//

import Foundation

struct SearchedMovie: Decodable {
    var page: Int
    var results: [SearchedMovieInfo]
    let total_pages: Int
    let total_results: Int
}

struct SearchedMovieInfo: Decodable {
    let adult: Bool
    let backdrop_path, poster_path: String?
    let original_title, overview, title: String
    let id: Int
}
