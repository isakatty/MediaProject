//
//  TrendViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/10/24.
//

import Foundation

final class TrendViewModel {
    private var initFavList: [String] = FavoriteRepository.shared.readFavorites().map { String($0.id) }
    
    var inputViewDidLoad = Observable<Void>(())
    var inputFilterFavsTrigger = Observable<Void>(())
    var inputMovieSelectedTrigger = Observable<Int?>(nil)
    var changedFavsTrigger = Observable<Void>(())
    
    private(set) var outputTrendMovie = Observable(TrendMovieResponseDTO(page: 1, media: []))
    private(set) var outputListCount = Observable(1)
    private(set) var outputIndex = Observable<Int>(0)
    private(set) var outputMovieResponse = Observable<MovieResponseDTO?>(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            self.fetchTrendData()
        }
        inputMovieSelectedTrigger.bind { [weak self] movieId in
            guard let self, let movieId else { return }
            self.outputMovieResponse.value = self.outputTrendMovie.value.media[movieId]
        }
        inputFilterFavsTrigger.bind { [weak self] _ in
            guard let self else { return }
            fetchRealmFav()
        }
        changedFavsTrigger.bind { [weak self] _ in
            guard let self else { return }
            checkAndUpdateFavorites()
        }
    }
    
    private func fetchTrendData() {
        NetworkService.shared.callRequest(
            endpoint: .trendingMovie,
            type: TrendMovieResponse.self
        ) { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    self.outputTrendMovie.value = success.toDomain
                    self.outputListCount.value = self.outputTrendMovie.value.media.count
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
        }
    }
    private func fetchRealmFav() {
        outputTrendMovie.value.media.removeAll()
        let favIds: [String] = FavoriteRepository.shared.readFavorites().map { String($0.id) }
        for favId in favIds {
            NetworkService.shared.callRequest(
                endpoint: .movieDetails(movieId: favId),
                type: MovieDetailResponse.self
            ) { [weak self] response in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch response {
                    case .success(let success):
                        self.outputTrendMovie.value.media.append(success.toDTO)
                    case .failure(let failure):
                        print(failure.errorDescription ?? "")
                    }
                }
            }
        }
        outputListCount.value = outputTrendMovie.value.media.count
    }
    func checkAndUpdateFavorites() {
        let recentFavList: [String] = FavoriteRepository.shared.readFavorites().map { String($0.id) }
        print(recentFavList)
        if initFavList != recentFavList {
            fetchRealmFav()
            initFavList = recentFavList
        }
    }
}
