//
//  SearchViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

import SnapKit

enum SearchFlow {
    case search
    case memoToSearch
}

final class SearchViewController: BaseViewController {
    var searchFlow: SearchFlow
    let searchViewModel = SearchViewModel()
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
    private let emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = false
        return view
    }()
    
    init(searchFlow: SearchFlow) {
        self.searchFlow = searchFlow
        
        super.init(viewTitle: ViewCase.search.viewTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        searchViewModel.page.value = 1
        searchViewModel.isLastData.value = false
        searchViewModel.outputEmptyList.onNext { [weak self] isEmpty in
            guard let self else { return }
            if !isEmpty {
                self.emptyView.isHidden = true
                self.movieCollectionView.isHidden = false
            } else {
                self.movieCollectionView.isHidden = true
                self.emptyView.isHidden = false
            }
        }
        searchViewModel.outputSearchedMovieList.bind { [weak self] data in
            guard let self else { return }
            if !data.results.isEmpty {
                self.movieCollectionView.reloadData()
                if self.searchViewModel.page.value == 1 {
                    self.movieCollectionView.scrollToItem(
                        at: .init(
                            item: 0,
                            section: 0
                        ),
                        at: .top,
                        animated: false
                    )
                }
            }
        }
        searchViewModel.outputSearchFlow.bind { [weak self] _ in
            guard let self else { return }
            
            let vc = TrendMovieDetailViewController(viewModel: TrendDetailViewModel(movieInfo: self.searchViewModel.changedMovieDTO.value))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        searchViewModel.outputMemoFlow.bind { [weak self] _ in
            guard let self else { return }
            
            self.searchViewModel.delegate?.passSelectedMovieInfo(movie: self.searchViewModel.changedMovieDTO.value)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func configureHierarchy() {
        [searchBar, movieCollectionView, emptyView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(44)
        }
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.leading.trailing.equalTo(safeArea)
        }
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(60)
            make.height.equalTo(emptyView.snp.width)
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.inputSearchBarText.value = searchBar.text
    }
}

extension SearchViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return searchViewModel.outputSearchedMovieList.value.results.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchMovieCollectionViewCell
        else { return UICollectionViewCell() }
        
        let movie = searchViewModel.outputSearchedMovieList.value
            .results[indexPath.item].poster_path
        
        cell.configureUI(with: movie)
        
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        searchViewModel.inputSelectedIndex.value = indexPath.item
        switch searchFlow {
        case .search:
            searchViewModel.inputSearchFlow.value = ()
        case .memoToSearch:
            searchViewModel.inputMemoFlow.value = ()
        }
    }
}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        for path in indexPaths {
            let isReadyToPagenation = searchViewModel.outputSearchedMovieList.value.results.count - 5 == path.item
            if isReadyToPagenation && searchViewModel.isLastData.value == false {
                searchViewModel.loadMoreMovies()
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        print(#function)
    }
}
