//
//  TrendDetailViewModel.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/11/24.
//

import Foundation

final class TrendDetailViewModel {
    let movieInfo: MovieResponseDTO
    
    /// viewDidLoad될 때 감지 센서
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    /// TMDB API 통신 완료 감지 센서
    var catchedDataFetch: Observable<Bool> = Observable(false)
    var inputVideoBtnTrigger: Observable<Int> = Observable(0)
    var inputFavBtnTrigger: Observable<Int> = Observable(0)
    
    private(set) var outputFavoriteMovie: Observable<Bool> = Observable(false)
    private(set) var outputSectionItems: Observable<[Int]> = Observable(
        .init(
            repeating: 1,
            count: TrendDetailSectionKind.allCases.count
        )
    )
    private(set) var outputCastData = Observable<[CastResponseDTO]>([])
    private(set) var outputPosterData = Observable<[PosterPathResponseDTO]>([])
    private(set) var outputSimilarData = Observable<[SimilarDTO]>([])
    private(set) var outputVideoInfo: Observable<(String?, String?)> = Observable((nil,nil))
    
    init(movieInfo: MovieResponseDTO) {
        self.movieInfo = movieInfo
        
        transform(movieInfo: movieInfo)
    }
    
    deinit {
        print(#file, "Detail Trend VM deinit")
    }
    
    private func transform(movieInfo: MovieResponseDTO) {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            self.requestDetails(movieId: movieInfo.id)
            self.outputFavoriteMovie.value = self.fetchFavorite(movieInfo.id)
        }
        inputVideoBtnTrigger.bind { [weak self] movieId in
            guard let self else { return }
            self.requestVideo(movieId: movieId)
        }
        inputFavBtnTrigger.bind { [weak self] movieId in
            guard let self else { return }
            // realm에 저장하거나 지우거나
            self.outputFavoriteMovie.value = self.handleFavorite(movieId)
        }
    }
    
    private func requestDetails(movieId: Int) {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.requestMovieDetail(movieId: movieId, dispatchGroup: group)
        }
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.requestPoster(movieId: movieId, dispatchGroup: group)
        }
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.requestRecommends(movieId: movieId, dispatchGroup: group)
        }
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.catchedDataFetch.value = true
        }
    }
    private func requestVideo(movieId: Int) {
        NetworkService.shared.callRequest(
            endpoint: .movieVideo(movieId: movieId),
            type: MovieVideoResponse.self
        ) { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    if let firstVideo = success.toDTO.movieVideos.first {
                        let urlString: String = VideoRequest.video(key: firstVideo.movieKey).toURLString
                        self.outputVideoInfo.value = (firstVideo.movieName, urlString)
                    } else {
                        self.outputVideoInfo.value.0 = "nope"
                        self.outputVideoInfo.value.1 = "There's no first video info"
                    }
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
        }
    }
    private func requestMovieDetail(movieId: Int, dispatchGroup: DispatchGroup) {
        NetworkService.shared.callRequest(
            endpoint: .trendCredits(movieId: String(movieId)),
            type: MovieCreditResponse.self
        ) { [weak self] response in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    self.outputCastData.value = success.toDTO.cast
                    self.outputSectionItems.value[1] = success.toDTO.cast.count
                    
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
            dispatchGroup.leave()
        }
    }
    private func requestRecommends(movieId: Int, dispatchGroup: DispatchGroup) {
        NetworkService.shared.callRequest(
            endpoint: .recommends(movieId: String(movieId)),
            type: SimilarMoviesResponse.self
        ) { [weak self] response in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    self.outputSectionItems.value[3] = success.toDTO.results.count
                    self.outputSimilarData.value = success.toDTO.results
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
            dispatchGroup.leave()
        }
    }
    private func requestPoster(movieId: Int, dispatchGroup: DispatchGroup) {
        NetworkService.shared.callRequest(
            endpoint: .images(movieId: String(movieId)),
            type: PosterResponse.self
        ) { [weak self] response in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    self.outputSectionItems.value[2] = success.toDTO.backdrops.count
                    self.outputPosterData.value = success.toDTO.backdrops
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
            dispatchGroup.leave()
        }
    }
    private func handleFavorite(_ movieId: Int) -> Bool {
        let favorites = FavoriteRepository.shared.readFavorites()
        
        // movieId가 favorites에 있으면 delete 아님
        if favorites.contains(where: { $0.id == movieId }) {
            // 삭제
            FavoriteRepository.shared.deleteFavorite(movieId)
            return false
        } else {
            // 저장
            FavoriteRepository.shared.createFavorite(movieId)
            return true
        }
    }
    private func fetchFavorite(_ movieId: Int) -> Bool {
        let favorites = FavoriteRepository.shared.readFavorites()
        
        if favorites.contains(where: { $0.id == movieId }) {
            return true
        } else {
            return false
        }
    }
}
