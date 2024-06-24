//
//  SimilarMovieViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

public final class SimilarMovieViewController: UIViewController {
    public var movie: MovieInfo
    private var similarMovies: SimilarMovies = .init(
        page: 0,
        results: [],
        total_pages: 0,
        total_results: 0
    )
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel().makeLabel(text: movie.title)
        return label
    }()
    private let similarMoviesLabel = UILabel().makeLabel(
        font: Constant.Font.bold19,
        text: "비슷한 영화"
    )
    private let recommendMoviesLabel = UILabel().makeLabel(
        font: Constant.Font.bold19,
        text: "추천 영화"
    )
    
    private lazy var similarCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout(
                cellWidthRatio: 0.28,
                cellHeightRatio: 1.0
            )
        )
        collection.register(
            MoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
        )
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    public init(movie: MovieInfo) {
        self.movie = movie
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(with: movie)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        [movieTitle, similarMoviesLabel, similarCollectionView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea).inset(12)
        }
        similarMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(8)
            make.leading.equalTo(safeArea).inset(12)
        }
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarMoviesLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(similarCollectionView.snp.width).multipliedBy(0.42)
        }
    }
    private func configureUI() {
        view.backgroundColor = .white
    }
    private func fetchData(with movie: MovieInfo) {
        NetworkService.shared.callSimilarTMDB(
            movieID: movie.id
        ) { [weak self] movies in
            guard let self = self else { return }
            self.similarMovies = movies
            self.similarCollectionView.reloadData()
        }
    }
    
    private func collectionViewLayout(
        cellWidthRatio: CGFloat,
        cellHeightRatio: CGFloat
    ) -> UICollectionViewLayout {
        // item - item 자체를 뷰 꽉채움
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // group - group의 사이즈를 cell이 보여질 사이즈
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(cellWidthRatio),
            heightDimension: .fractionalHeight(cellHeightRatio)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(10)
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        layout.configuration = configuration

        return layout
    }
}

extension SimilarMovieViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return similarMovies.results.count
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
        cell.configureUI(movieInfo: similarMovies.results[indexPath.item])
        return cell
    }
}
