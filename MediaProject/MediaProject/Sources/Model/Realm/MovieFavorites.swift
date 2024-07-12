//
//  MovieFavorites.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

final class MovieFavorites: Object {
    
    @Persisted(primaryKey: true) var id: Int // PK - TMDB의 MovieId
    @Persisted var title: String
    @Persisted var poster: String
    @Persisted var overview: String
    @Persisted var releaseDate: String
    @Persisted var voteAvg: Double
    @Persisted var voteCount: Int
    
    convenience init(
        id: Int,
        title: String,
        poster: String,
        overview: String,
        releaseDate: String,
        voteAvg: Double,
        voteCount: Int
    ) {
        self.init()
        self.id = id
        self.title = title
        self.poster = poster
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAvg = voteAvg
        self.voteCount = voteCount
    }
}
