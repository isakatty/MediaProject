//
//  SearchViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

import Kingfisher
import SnapKit

public class SearchViewController: UIViewController {
    private var page: Int = 1
    private var isLastData: Bool = false
    private var searchedMovieList: SearchedMovie = SearchedMovie(
        page: 1,
        results: [],
        total_pages: 1,
        total_results: 1
    )
    private lazy var movieCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        collection.register(
            SearchMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchMovieCollectionViewCell.identifier
        )
        return collection
    }()
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "영화를 검색하세요."
        return bar
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [searchBar, movieCollectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(44)
        }
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(safeArea)
        }
    }
    private func handleSearchedMovie(movie: SearchedMovie) {
        if movie.page == movie.total_pages {
            isLastData = true
        }
        if page == 1 {
            searchedMovieList = movie
        } else {
            searchedMovieList.results.append(contentsOf: movie.results)
        }
        movieCollectionView.reloadData()
        if page == 1 {
            movieCollectionView.scrollToItem(
                at: .init(
                    item: 0,
                    section: 0
                ),
                at: .top,
                animated: false
            )
        }
    }
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = .init(width: width / 3, height: width * 4 / 9)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        return layout
    }
}

extension SearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        isLastData = false
        searchedMovieList.results.removeAll()
        guard let text = searchBar.text else { return }
        NetworkService.shared.callTMDB(
            endPoint: .search(
                movieName: text,
                page: page
            ),
            type: SearchedMovie.self
        ) { [weak self] searchedMovie, error in
            if let error {
                print(#file, #function, "검색 에러", error)
            } else {
                guard let self else { return }
                guard let searchedMovie else { return }
                handleSearchedMovie(movie: searchedMovie)
            }
        }
    }
}

extension SearchViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return searchedMovieList.results.count
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchMovieCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configureUI(with: searchedMovieList.results[indexPath.item].poster_path ?? "")
        
        return cell
    }
}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        for path in indexPaths {
            let isReadyToPagenation = searchedMovieList.results.count - 6 == path.item
            if isReadyToPagenation && isLastData == false {
                page += 1
                guard let text = searchBar.text else { return }
                NetworkService.shared.callTMDB(
                    endPoint: .search(
                        movieName: text,
                        page: page
                    ),
                    type: SearchedMovie.self
                ) { [weak self] searchedMovie, error in
                    if let error {
                        print(#file, #function, "검색 에러", error)
                    } else {
                        guard let self else { return }
                        guard let searchedMovie else { return }
                        handleSearchedMovie(movie: searchedMovie)
                    }
                }
            }
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        print(#function)
    }
}
