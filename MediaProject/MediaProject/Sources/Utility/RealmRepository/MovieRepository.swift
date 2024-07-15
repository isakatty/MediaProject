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
    
    func readMovies() -> [Movie] {
        let movie = realm.objects(Movie.self)
        return Array(movie)
    }
    
    func findMemoFromDate(selectedDate: Date) -> [MovieMemo] {
        let movies = readMovies()
        
        let memo = movies.flatMap { $0.memo }
            .filter {
                DateFormatterManager.shared.isSameDate(
                    date1: $0.regDate,
                    date2: selectedDate
                )
            }
        return memo
    }
    
    func createMovieMemo(movie: Movie) {
        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            
        }
    }
    
}
