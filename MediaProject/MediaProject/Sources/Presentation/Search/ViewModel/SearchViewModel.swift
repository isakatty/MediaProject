//
//  SearchViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

final class SearchViewModel {
    weak var delegate: PassMovieResponse?
    
    var page: Observable<Int> = Observable(1)
    var isLastData: Observable<Bool> = Observable(false)
    var inputSearchBarText: Observable<String?> = Observable(nil)
    var inputSelectedIndex: Observable<Int> = Observable(9999)
    var inputSearchFlow = Observable<Void?>(nil)
    var inputMemoFlow = Observable<Void?>(nil)
    
    var outputSearchedMovieList: Observable<SearchResponseDTO> = Observable(
        SearchResponseDTO(
            page: 1,
            results: [],
            total_pages: 1,
            total_results: 1
        )
    )
    var changedMovieDTO: Observable<MovieResponseDTO> = Observable(
        MovieResponseDTO(
            id: 1,
            title: "",
            poster_path: "",
            backdrop_path: "",
            releaseDate: "",
            overView: "",
            voteAvg: 0.1,
            voteCnt: 1
        )
    )
    var outputEmptyList: Observable<Bool> = Observable(true)
    var outputSearchFlow = Observable<Void?>(nil)
    var outputMemoFlow = Observable<Void?>(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputSearchBarText.bind { [weak self] word in
            guard let word else { return }
            guard let self else { return }
            self.page.value = 1
            self.isLastData.value = false
            self.searchMovie(with: word)
        }
        inputSelectedIndex.bind { [weak self] index in
            guard let self else { return }
            self.changeDTO(index: index)
        }
        inputSearchFlow.bind { [weak self] _ in
            guard let self else { return }
            self.outputSearchFlow.value = ()
        }
        inputMemoFlow.bind { [weak self] _ in
            guard let self else { return }
            self.outputMemoFlow.value = ()
        }
    }
    
    private func searchMovie(with keyword: String) {
        NetworkService.shared.callRequest(
            endpoint: .search(
                movieName: keyword,
                page: page.value
            ),
            type: SearchMovieResponse.self
        ) { [weak self] response in
            guard let self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let success):
                    self.handleSearchedMovie(movie: success)
                    self.outputEmptyList.value = self.outputSearchedMovieList.value.results.isEmpty
                case .failure(let failure):
                    print(failure.errorDescription ?? "")
                }
            }
        }
    }
    
    private func handleSearchedMovie(movie: SearchMovieResponse) {
        if movie.page == movie.total_pages {
            isLastData.value = true
        }
        if page.value == 1 {
            outputSearchedMovieList.value = movie.toDTO
        } else {
            outputSearchedMovieList.value.page = page.value
            outputSearchedMovieList.value.results.append(contentsOf: movie.toDTO.results)
        }
    }
    private func changeDTO(index: Int) {
        let data = outputSearchedMovieList.value.results[index]
        
        changedMovieDTO.value = .init(
            id: data.id,
            title: data.title,
            poster_path: data.poster_path,
            backdrop_path: data.backdrop_path,
            releaseDate: data.release_date,
            overView: data.overview,
            voteAvg: data.vote_average,
            voteCnt: data.vote_count
        )
    }
    
    func loadMoreMovies() {
        guard !isLastData.value else { return }
        page.value += 1
        guard let keyword = inputSearchBarText.value else { return }
        searchMovie(with: keyword)
    }
}
