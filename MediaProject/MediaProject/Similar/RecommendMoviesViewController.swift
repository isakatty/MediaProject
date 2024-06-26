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
    private let labelTitle: [String] = ["비슷한 영화", "추천 영화", "포스터"]
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
        return labelTitle.count
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
        
        switch indexPath.row {
        case 0,1:
            tableView.rowHeight = 220
        case 2:
            tableView.rowHeight = 260
        default:
            tableView.rowHeight = 220
        }
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
        switch collectionView.tag {
        case 0,1:
            return moviePosterArrays[collectionView.tag].count
        case 2:
            return posterArrays.count
        default:
            return moviePosterArrays[collectionView.tag].count
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviesCollectionViewCell.identifier,
            for: indexPath
        ) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
        
        switch collectionView.tag {
        case 0,1:
            cell.configureUI(path: moviePosterArrays[collectionView.tag][indexPath.item].poster_path)
        case 2:
            cell.configureUI(path: posterArrays[indexPath.item].file_path)
        default:
            cell.configureUI(path: moviePosterArrays[collectionView.tag][indexPath.item].poster_path)
        }
        return cell
    }
}
