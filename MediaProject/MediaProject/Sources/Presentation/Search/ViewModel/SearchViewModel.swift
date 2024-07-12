//
//  SearchViewModel.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import Foundation

final class SearchViewModel {
    var page: Observable<Int> = Observable(1)
    var isLastData: Observable<Bool> = Observable(false)
    var inputSearchBarText: Observable<String?> = Observable(nil)
    var inputSelectedIndex: Observable<Int> = Observable(9999)
    
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
    }
    
    private func searchMovie(with keyword: String) {
        NetworkService.shared.callTMDB(
            endPoint: .search(
                movieName: keyword,
                page: page.value
            ),
            type: SearchMovieResponse.self
        ) { [weak self] searchedMovie, error in
            guard let self else { return }
            guard error == nil else {
                print(NetworkError.invalidError.errorDescription ?? "")
                return
            }
            guard let searchedMovie else {
                print(NetworkError.invalidResponse.errorDescription ?? "")
                return
            }
            handleSearchedMovie(movie: searchedMovie)
            // outputEmptyList.value 줘야함
            if !self.outputSearchedMovieList.value.results.isEmpty {
                self.outputEmptyList.value = false
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
