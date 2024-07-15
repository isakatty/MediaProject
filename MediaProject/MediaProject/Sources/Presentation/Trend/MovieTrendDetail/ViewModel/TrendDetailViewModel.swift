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
    
    var outputFavoriteMovie: Observable<Bool> = Observable(false)
    var outputSectionItems: Observable<[Int]> = Observable(
        .init(
            repeating: 1,
            count: TrendDetailSectionKind.allCases.count
        )
    )
    var outputSectionDatas: Observable<[TrendCollection]> = Observable([])
    var outputVideoInfo: Observable<(String?, String?)> = Observable((nil,nil))
    
    init(movieInfo: MovieResponseDTO) {
        self.movieInfo = movieInfo
        
        transform(movieInfo: movieInfo)
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
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .trendDetail(movieId: String(movieId)),
                type: MovieCreditResponse.self
            ) { [weak self] cast, error in
                if let error {
                    print("cast - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let cast else {
                        print(NetworkError.invalidResponse.errorDescription!)
                        return
                    }
                    self.outputSectionDatas.value.append (
                        TrendCollection(
                            actorInfo: cast.toDTO.cast,
                            poster: nil,
                            similar: nil
                        )
                    )
                    outputSectionItems.value[1] = cast.toDTO.cast.count
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .images(movieId: String(movieId)),
                type: PosterResponse.self
            ) { [weak self] files, error in
                if let error {
                    print("similar - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let files else {
                        print(NetworkError.invalidResponse.errorDescription!)
                        return
                    }
                    self.outputSectionDatas.value.append(
                        TrendCollection(
                            actorInfo: nil,
                            poster: files.toDTO.backdrops,
                            similar: nil
                        )
                    )
                    outputSectionItems.value[2] = files.toDTO.backdrops.count
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .recommends(movieId: String(movieId)),
                type: TrendMovies.self
            ) { [weak self] movies, error in
                if let error {
                    print("Recommend - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let movies else {
                        print(NetworkError.invalidResponse.errorDescription!)
                        return
                    }
                    self.outputSectionDatas.value.append(
                        TrendCollection(
                            actorInfo: nil,
                            poster: nil,
                            similar: movies.results
                        )
                    )
                    outputSectionItems.value[3] = movies.results.count
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("여기까지 옴")
            self.catchedDataFetch.value = true
        }
    }
    private func requestVideo(movieId: Int) {
        NetworkService.shared.callTMDB(
            endPoint: .movieVideo(movieId: movieId),
            type: MovieVideoResponse.self
        ) { [weak self] video, err in
            guard let self else { return }
            guard err == nil else {
                print(NetworkError.invalidError.errorDescription ?? "")
                return
            }
            guard let video else { return }
            if let firstVideo = video.toDTO.movieVideos.first {
                let urlString: String = VideoRequest.video(key: firstVideo.movieKey).toURLString
                self.outputVideoInfo.value = (firstVideo.movieName, urlString)
            } else {
                self.outputVideoInfo.value.0 = "nope"
                self.outputVideoInfo.value.1 = "There's no first video info"
            }
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
