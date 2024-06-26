//
//  RecommendMoviesViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import UIKit

// MARK: TableView 안에 CollectionView 좌우 스크롤

public final class RecommendMoviesViewController: UIViewController {
    public var movie: MovieInfo
    private var moviePosterArrays: [[TrendInfo]] = [[],[]]
    private var posterArrays: [PosterPath] = []
    
    private lazy var multiMoviesTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(
            RecommendTableViewCell.self,
            forCellReuseIdentifier: RecommendTableViewCell.id
        )
        table.rowHeight = 220
        return table
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
        
        network()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        view.addSubview(multiMoviesTableView)
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        multiMoviesTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    private func network() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callSimilarTMDB(movieID: self.movie.id) { [weak self] movies in
                guard let self = self else { return }
                self.moviePosterArrays[0] = movies.results
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callRecommendTMDB(endPoint: RecommendEndPoint(
                movieID: String(self.movie.id),
                authKey: Constant.Endpoint.TMDB_key
            )) { [weak self] movies in
                guard let self = self else { return }
                self.moviePosterArrays[1] = movies.results
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callPosterImage(
                endPoint: PosterEndPoint(
                    movieId: String(
                        self.movie.id
                    ),
                    authKey: Constant.Endpoint.TMDB_key
                )
            ){ [weak self] poster in
                guard let self = self else { return }
                self.posterArrays.append(contentsOf: poster.backdrops)
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.multiMoviesTableView.reloadData()
        }
    }
}
extension RecommendMoviesViewController
: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return TableViewSection.allCases.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecommendTableViewCell.id,
            for: indexPath
        ) as? RecommendTableViewCell else { return UITableViewCell() }
        
        cell.similarCollectionView.dataSource = self
        cell.similarCollectionView.delegate = self
        cell.similarCollectionView.tag = indexPath.row
        cell.configureUI(text: labelTitle[indexPath.row])
        
        tableView.rowHeight = TableViewSection.allCases[indexPath.row].rowHeight
        cell.similarCollectionView.reloadData()
        return cell
    }
}

extension RecommendMoviesViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = TableViewSection(rawValue: collectionView.tag) else { return 0}
        
        switch section {
        case .similar, .recommend:
            return moviePosterArrays[section.rawValue].count
        case .poster:
            return posterArrays.count
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as? MoviesCollectionViewCell,
              let section = TableViewSection(rawValue: collectionView.tag) else { return UICollectionViewCell() }
        
        switch section {
        case .similar, .recommend:
            cell.configureUI(path: moviePosterArrays[section.rawValue][indexPath.item].poster_path)
        case .poster:
            cell.configureUI(path: posterArrays[indexPath.item].file_path)
        }
        return cell
    }
}
