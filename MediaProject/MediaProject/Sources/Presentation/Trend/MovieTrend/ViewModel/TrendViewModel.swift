//
//  TrendViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/10/24.
//

import Foundation

final class TrendViewModel {
    var inputSegTrigger: Observable<Int> = Observable(0)
    
    var outputTrendMovie = Observable(TrendMovieResponseDTO(page: 1, media: []))
    var outputTrendTV = Observable(TrendTVResponseDTO(page: 1, media: []))
    var outputListCount = Observable(1)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputSegTrigger.bind { [weak self] segIndex in
            guard let self else { return }
            print("시점 확인용 - input 데이터")
            self.fetchTrendData(index: segIndex)
            print("시점 확인용 - fetch 끝")
        }
    }
    
    private func fetchTrendData(index: Int) {
        // segmentedIndex랑 enum의 rawValue 비교해서 데이터 fetch 하기
        if index == Trends.movie.rawValue {
            print("통신하러 들어가는 중")
            // TMDB 영화
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
                print("통신 중")
                self.outputTrendMovie.value = response.toDomain
                self.outputListCount.value = self.outputTrendMovie.value.media.count
                print("결과값 넣기완")
            }
        } else if index == Trends.tv.rawValue {
            // TMDB 드라마
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
        
        print("fetch 완")
    }
}
