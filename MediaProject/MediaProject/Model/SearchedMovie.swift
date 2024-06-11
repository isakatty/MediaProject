//
//  SearchedMovie.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/12/24.
//

import Foundation

public struct SearchedMovie: Decodable {
    let page: Int?
    let results: [SearchedMovieInfo]
    let total_pages: Int
    let total_results: Int
}

public struct SearchedMovieInfo: Decodable {
    let adult: Bool
    let backdrop_path, original_title, overview, poster_path, title: String
    let id: Int
}
