//
//  NewTrendViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

import SnapKit

enum Trends: Int, CaseIterable {
    case movie = 0
    case tv
    
    var description: String {
        switch self {
        case .movie:
            return "Movie"
        case .tv:
            return "TV"
        }
    }
}

final class NewTrendViewController: BaseViewController {
    
    private var trendMovie = TrendMovieResponseDTO(page: 1, media: [MovieResponseDTO.init(id: 0, title: "", poster_path: "", backdrop_path: "", releaseDate: "", overView: "", voteAvg: 10.0, voteCnt: 1)])
    private var trendTV  = TrendTVResponseDTO(page: 1, media: [TVResponseDTO.init(id: 1, name: "", poster_path: "")])
    
    private lazy var segments: UISegmentedControl = {
        let segmentItems = Trends.allCases.map { $0.description }
        let segmnets = UISegmentedControl(items: segmentItems)
        segmnets.selectedSegmentIndex = Trends.movie.rawValue
        segmnets.addTarget(self, action: #selector(segTapped), for: .valueChanged)
        return segmnets
    }()
    private lazy var trendCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionLayout()
        )
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            TrendCollectionViewCell.self,
            forCellWithReuseIdentifier: TrendCollectionViewCell.identifier
        )
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(segmentedIndex: segments.selectedSegmentIndex)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        [segments, trendCollectionView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        segments.snp.makeConstraints { make in
            make.top.centerX.equalTo(safeArea)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        trendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segments.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    func configureUI() {
        
    }
    private func fetchData(segmentedIndex: Int) {
        // segmentedIndex랑 enum의 rawValue 비교해서 데이터 fetch 하기
        if segmentedIndex == Trends.movie.rawValue {
            // TMDB 영화
            NetworkService.shared.callTMDB(
                endPoint: .trendingMovie,
                type: TrendMovieResponse.self
            ) { [weak self] response, error in
                guard error == nil else {
                    print(NetworkError.invalidError.errorDescription ?? "")
                    return
                }
                guard let response else {
                    print(NetworkError.invalidResponse.errorDescription ?? "")
                    return
                }
                guard let self else { return }
                self.trendMovie = response.toDomain
                self.trendCollectionView.reloadData()
            }
        } else if segmentedIndex == Trends.tv.rawValue {
            // TMDB 드라마
            NetworkService.shared.callTMDB(
                endPoint: .trendingTV,
                type: TrendTVResponse.self
            ) { [weak self] response, error in
                guard error == nil else {
                    print(NetworkError.invalidError.errorDescription ?? "")
                    return
                }
                guard let response else {
                    print(NetworkError.invalidResponse.errorDescription ?? "")
                    return
                }
                guard let self else { return }
                self.trendTV = response.toDTO
                self.trendCollectionView.reloadData()
            }
        }
    }
    
    private func configureCollectionLayout() -> UICollectionViewLayout {
        // item - item 자체를 뷰 꽉채움
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // group - group의 사이즈를 cell이 보여질 사이즈
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(2 / 7)
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
        
        return layout
    }
    /// segmentedController에 사용자 액션이 일어나 값이 변할 때 불리는 함수
    @objc func segTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case Trends.movie.rawValue:
            fetchData(segmentedIndex: Trends.movie.rawValue)
        case Trends.tv.rawValue:
            fetchData(segmentedIndex: Trends.tv.rawValue)
        default:
            break
        }
    }
}

extension NewTrendViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch segments.selectedSegmentIndex {
        case Trends.movie.rawValue:
            return trendMovie.media.count
        case Trends.tv.rawValue:
            return trendTV.media.count
        default:
            return trendMovie.media.count
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendCollectionViewCell.identifier,
            for: indexPath
        ) as? TrendCollectionViewCell else { return UICollectionViewCell() }
        
        switch segments.selectedSegmentIndex {
        case Trends.movie.rawValue:
            let movies = trendMovie.media[indexPath.item]
            cell.configureUI(
                posterPath: movies.poster_path,
                numberIndex: indexPath.item + 1,
                titleName: movies.title
            )
        case Trends.tv.rawValue:
            let tvs = trendTV.media[indexPath.item]
            cell.configureUI(
                posterPath: tvs.poster_path,
                numberIndex: indexPath.item,
                titleName: tvs.name
            )
        default:
            let movies = trendMovie.media[indexPath.item]
            cell.configureUI(
                posterPath: movies.poster_path,
                numberIndex: indexPath.item + 1,
                titleName: movies.title
            )
        }
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch segments.selectedSegmentIndex {
        case Trends.movie.rawValue:
            print("Detailview")
            let vc = TrendMovieDetailViewController(movieInfo: trendMovie.media[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case Trends.tv.rawValue:
            print("아무일도 일어나지 않음")
        default:
            print("아무일도 일어나지 않음")
        }
    }
}
