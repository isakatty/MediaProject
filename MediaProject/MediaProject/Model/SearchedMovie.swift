//
//  SearchedMovie.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/12/24.
//

import Foundation

public struct SearchedMovie: Decodable {
    let page: Int
    var results: [SearchedMovieInfo]
    let total_pages: Int
    let total_results: Int
}

public struct SearchedMovieInfo: Decodable {
    let adult: Bool
    let backdrop_path, poster_path: String?
    let original_title, overview, title: String
    let id: Int
}
