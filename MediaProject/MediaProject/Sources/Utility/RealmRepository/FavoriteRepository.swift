//
//  FavoriteRepository.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

import RealmSwift

enum MovieFavoritesError {
    case createFavError
    case readFavError
    case deleteFavError
    
    var errorDescription: String {
        switch self {
        case .createFavError:
            "즐겨찾기 DB 저장 오류"
        case .readFavError:
            "즐겨찾기 DB Fetch 오류"
        case .deleteFavError:
            "즐겨찾기 DB 삭제 오류"
        }
    }
}

final class FavoriteRepository {
    static let shared = FavoriteRepository()
    private let realm = try! Realm()
    
    private init() {
        print(realm.configuration.fileURL)
    }
    
    func createFavorite(_ movieId: Int) {
        let movie = MovieFavorites(id: movieId)
        do {
            try realm.write {
                realm.add(movie)
            }
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        } catch {
            print(MovieFavoritesError.createFavError.errorDescription)
        }
    }
    func readFavorites() -> [MovieFavorites] {
        let favorites = realm.objects(MovieFavorites.self)
        return Array(favorites)
    }
    func deleteFavorite(_ movieId: Int) {
        guard let favMovie = realm.object(
            ofType: MovieFavorites.self,
            forPrimaryKey: movieId
        ) else {
            print(MovieFavoritesError.readFavError.errorDescription)
            return
        }
        
        do {
            try realm.write {
                realm.delete(favMovie)
            }
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        } catch {
            print(MovieFavoritesError.deleteFavError.errorDescription)
        }
    }
}
