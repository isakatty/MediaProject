//
//  TrendViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/10/24.
//

import Foundation

final class TrendViewModel {
    var inputViewDidLoad = Observable<Void>(())
    var inputMovieSelectedTrigger = Observable<Int?>(nil)
    
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
}
