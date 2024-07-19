//
//  MovieRepository.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

enum MovieMemoError: Error {
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
            print(MovieMemoError.createError.errorDescription)
        }
    }
    
    func addMemoToMovie(movie: Movie, memo: MovieMemo) {
        do {
            try realm.write {
                movie.memo.append(memo)
            }
        } catch {
            print(MovieMemoError.updateError.errorDescription)
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
            print(MovieMemoError.updateError.errorDescription)
        }
    }
    
    func removeMemoWithMovie(movie: Movie, memo: MovieMemo) {
        // 무비를 받고, 메모를 받음
        //
        // 무비에 메모가 받은 메모 하나다 -> 메모 날리고 무비 지우기
        // 무비에 메모가 여러개이다 -> 받은 메모 날리기
        do {
            try realm.write {
                if let memos = findMovieWithMemos(movieId: movie.id) {
                    if let memoToRemove = memos.first(where: { $0.id == memo.id }) {
                        if memos.count == 1 {
                            realm.delete(memoToRemove)
                            realm.delete(movie)
                        } else {
                            realm.delete(memoToRemove)
                        }
                    }
                }
            }
        } catch {
            print(MovieMemoError.deleteError.errorDescription)
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
    func findMovieWithMemos(movieId: Int) -> [MovieMemo]? {
        let movieWithMemos = realm.object(ofType: Movie.self, forPrimaryKey: movieId)?.memo
        guard let movieWithMemos else {
            print("Movie")
            return []
        }
        return Array(movieWithMemos)
    }
}
