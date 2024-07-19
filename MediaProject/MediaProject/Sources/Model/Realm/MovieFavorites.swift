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
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
}
