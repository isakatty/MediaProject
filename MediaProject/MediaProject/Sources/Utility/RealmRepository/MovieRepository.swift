//
//  MovieRepository.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

enum RepositoryError: Error {
    case createError
    case deleteError
    case updateError
    
    var errorDescription: String {
        switch self {
        case .createError:
            "추가 오류"
        case .deleteError:
            "삭제 오류"
        case .updateError:
            "Movie Memo 추가 오류"
        }
    }
}

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
    
    func createMovieWithMemo(movie: Movie) {
        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            print(RepositoryError.createError.errorDescription)
        }
    }
    
    func addMemoToMovie(movie: Movie, memo: MovieMemo) {
        do {
            try realm.write {
                movie.memo.append(memo)
            }
        } catch {
            print(RepositoryError.updateError.errorDescription)
        }
    }
    
    func updateMemo(movie: Movie, memo: MovieMemo) {
        do {
            try realm.write {
                guard let origin = findMemo(memo: memo) else { return }
                origin.title = memo.title
                origin.content = memo.content
                origin.watchedDate = memo.watchedDate
                origin.regDate = memo.regDate
                origin.tag = memo.tag
                realm.add(origin.self, update: .modified)
                movie.memo.replace(index: movie.memo.firstIndex(where: { $0.id == memo.id})!, object: origin)
            }
        } catch {
            print(RepositoryError.updateError.errorDescription)
        }
    }
    
    func findMovie(movieId: Int) -> (Bool, Movie?) {
        let movie = realm.object(ofType: Movie.self, forPrimaryKey: movieId)
        if let movie = movie {
            return (true, movie)
        } else {
            return (false, nil)
        }
    }
    
    func findMemo(memo: MovieMemo) -> MovieMemo? {
        let memo = realm.object(ofType: MovieMemo.self, forPrimaryKey: memo.id)
        return memo
    }
}
