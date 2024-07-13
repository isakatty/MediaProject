//
//  MovieRepository.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

final class MovieRepository {
    static let shared = MovieRepository()
    private let realm = try! Realm()
    
    private init() { 
        print(realm.configuration.fileURL)
    }
    
    func readMovies() -> [Movie]{
        let memoedMovie = realm.objects(Movie.self)
        return Array(memoedMovie)
    }
    
}
