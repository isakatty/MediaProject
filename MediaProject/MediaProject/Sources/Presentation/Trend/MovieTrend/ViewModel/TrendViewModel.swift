//
//  TrendViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/10/24.
//

import Foundation

final class TrendViewModel {
    var inputSegTrigger: Observable<Int> = Observable(0)
    var inputMovieSelectedTrigger = Observable<Int?>(nil)
    
    var outputTrendMovie = Observable(TrendMovieResponseDTO(page: 1, media: []))
    var outputTrendTV = Observable(TrendTVResponseDTO(page: 1, media: []))
    var outputListCount = Observable(1)
    var outputIndex = Observable<Int>(0)
    var outputMovieResponse = Observable<MovieResponseDTO?>(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputSegTrigger.bind { [weak self] segIndex in
            guard let self, let trend = Trends(rawValue: segIndex) else { return }
            self.fetchTrendData(trend: trend)
        }
        inputMovieSelectedTrigger.bind { [weak self] movieId in
            guard let self, let movieId else { return }
            self.outputMovieResponse.value = self.outputTrendMovie.value.media[movieId]
        }
    }
    
    private func fetchTrendData(trend: Trends) {
        switch trend {
        case .movie:
            NetworkService.shared.callTMDB(
                endPoint: .trendingMovie,
                type: TrendMovieResponse.self
            ) { [weak self] response, error in
                guard error == nil else {
                    print(NetworkError.invalidError.errorDescription ?? "")
                    return
                }
                guard let response else {
                    print(NetworkError.invalidResponse.errorDescription ?? "")
                    return
                }
                guard let self else { return }
                self.outputTrendMovie.value = response.toDomain
                self.outputListCount.value = self.outputTrendMovie.value.media.count
            }
        case .tv:
            NetworkService.shared.callTMDB(
                endPoint: .trendingTV,
                type: TrendTVResponse.self
            ) { [weak self] response, error in
                guard error == nil else {
                    print(NetworkError.invalidError.errorDescription ?? "")
                    return
                }
                guard let response else {
                    print(NetworkError.invalidResponse.errorDescription ?? "")
                    return
                }
                guard let self else { return }
                self.outputTrendTV.value = response.toDTO
                self.outputListCount.value = outputTrendTV.value.media.count
            }
        }
    }
}
