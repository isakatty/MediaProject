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
    
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold21
        label.textColor = UIColor.black
        label.text = movie.title
        return label
    }()
    
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
        [movieLabel, multiMoviesTableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let safeArea = view.safeAreaLayoutGuide
        movieLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea)
            make.top.equalTo(safeArea).offset(8)
            make.leading.equalTo(safeArea.snp.leading).inset(16)
            make.height.equalTo(movieLabel.snp.width).multipliedBy(0.05)
        }
        multiMoviesTableView.snp.makeConstraints { make in
            make.top.equalTo(movieLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    private func network() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .similarMovies(movieId: String(self.movie.id)),
                type: TrendMovies.self
            ) { [weak self] movies, error in
                if let error {
                    print("similar - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let movies else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.moviePosterArrays[0] = movies.results
                }
                group.leave()
            }
            
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .recommends(
                    movieId: String(
                        self.movie.id
                    )
                ),
                type: TrendMovies.self
            ) { [weak self] movies, error in
                if let error {
                    print("Recommend - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let movies else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.moviePosterArrays[1] = movies.results
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: NetworkRequest.images(movieId: String(self.movie.id)),
                type: Poster.self
            ) { [weak self] posters, error in
                
                if let error {
                    print("poster - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let posters else {
                        print("NetworkService - poster data X")
                        return
                    }
                    self.posterArrays.append(contentsOf: posters.backdrops)
                }
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
        cell.configureUI(text: TableViewSection.allCases[indexPath.row].title)
        cell.configureCollectionViewDimension(width: TableViewSection.allCases[indexPath.row].itemWidth)
        
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
        guard let section = TableViewSection(rawValue: collectionView.tag) else { return 0 }
        
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
              let section = TableViewSection(rawValue: collectionView.tag) 
        else { return UICollectionViewCell() }
        
        switch section {
        case .similar, .recommend:
            cell.configureUI(path: moviePosterArrays[section.rawValue][indexPath.item].poster_path)
        case .poster:
            cell.configureUI(path: posterArrays[indexPath.item].file_path)
        }
        return cell
    }
}
