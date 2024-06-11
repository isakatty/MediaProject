//
//  SearchViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

public class SearchViewController: UIViewController {
    private var page: Int = 1
    private var searchedMovieList: SearchedMovie = SearchedMovie(
        page: 1,
        results: [SearchedMovieInfo(
            adult: false, 
            backdrop_path: "",
            original_title: "",
            overview: "",
            poster_path: "",
            title: "",
            id: 1
        )],
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
    private func callRequest(with keyword: String) {
        let baseURL = PrivateKey.tmdb_Search_Movie_URL
        let query = "query=\(keyword)&include_adult=true&language=ko-KR&page=\(page)"
        let headers: HTTPHeaders = [
            "Authorization": PrivateKey.TMDB_key
        ]
        guard let url = URL(string: baseURL + query) else { return }
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: SearchedMovie.self) { [weak self] response in
            guard let self else { return }
            
            switch response.result {
            case .success(let value):
                self.searchedMovieList = value
                self.movieCollectionView.reloadData()
            case .failure(let err):
                print(err)
            }
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
        guard let text = searchBar.text else { return }
        callRequest(with: text)
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
        
        
        
        cell.configureUI(with: searchedMovieList.results[indexPath.item].poster_path)
        
        return cell
    }

    
}
