//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

enum SectionKind: Int, CaseIterable {
    case movieInfo = 0
    case cast
    case video
    
    var groupSize: [String: CGFloat] {
        switch self {
        case .movieInfo:
            return ["wid": 1.0, "hght": 0.5]
        case .cast:
            return ["wid": 2 / 9, "hght": 0.2]
        case .video:
            return ["wid": 1 / 3 , "hght": 0.2]
        }
    }
}

final class TrendMovieDetailViewController: BaseViewController {
    // 전View에서 받아올 값
    let movieInfo: MovieResponseDTO
    
    private var sectionItems: [Int] = .init(repeating: 1, count: SectionKind.allCases.count) {
        didSet {
            detailCollectionView.reloadData()
        }
    }
    private var sectionDetails: [TrendCollection] = [
        TrendCollection(
            actorInfo: [Cast.init(
                adult: true,
                id: 1,
                name: "",
                original_name: "",
                profile_path: "",
                character: ""
            )],
            similar: nil
        ),
        TrendCollection.init(
            actorInfo: nil,
            similar: [TrendInfo(poster_path: "")]
        )
    ]
    private lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrendMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: TrendMovieCollectionViewCell.identifier
        )
        collectionView.register(
            TrendMovieTitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TrendMovieTitleCollectionViewCell.identifier
        )
        collectionView.register(
            TrendMovieCastCell.self,
            forCellWithReuseIdentifier: TrendMovieCastCell.identifier
        )
        return collectionView
    }()
    
    init(movieInfo: MovieResponseDTO) {
        self.movieInfo = movieInfo
        
        super.init(viewTitle: movieInfo.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        DispatchQueue.main.async {
            self.configureUI()
        }
    }
    
    private func configureHierarchy() {
        [detailCollectionView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    private func configureUI() {
        // network 통신하고 item count 줘야함.
        requestDetails(movieId: movieInfo.id)
    }
    
    private func requestDetails(movieId: Int) {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .trendDetail(
                    movieId: String(movieId)
                ),
                type: MovieCredit.self
            ) { [weak self] cast, error in
                if let error {
                    print("cast - error가 있다 !", error)
                } else {
                    guard let self else { return }
                    guard let cast else {
                        print("NetworkService - similar movies X")
                        return
                    }
                    self.sectionDetails[0].actorInfo = cast.cast
                    sectionItems[1] = cast.cast.count
                }
                group.leave()
            }
        }
        group.enter()
        DispatchQueue.global().async {
            NetworkService.shared.callTMDB(
                endPoint: .similarMovies(movieId: String(self.movieInfo.id)),
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
                    self.sectionDetails[1].similar = movies.results
                    sectionItems[2] = movies.results.count
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("여기까지 옴")
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { return nil }
            switch sectionKind {
            case .movieInfo:
                return self.createVerticalSection(
                    widthRatio: sectionKind.groupSize["wid"]!,
                    heightRatio: sectionKind.groupSize["hght"]!
                )
            case .cast,
                    .video:
                return self.createHorizontalSection(
                    widthRatio: sectionKind.groupSize["wid"]!,
                    heightRatio: sectionKind.groupSize["hght"]!
                )
            }
        })
        
        return layout
    }
    private func createVerticalSection(
        widthRatio: CGFloat,
        heightRatio: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(
                1.0
            ),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(widthRatio),
            heightDimension: .fractionalHeight(heightRatio)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    private func createHorizontalSection(
        widthRatio: CGFloat,
        heightRatio: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(
                1.0
            )
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(widthRatio),
            heightDimension: .fractionalHeight(heightRatio)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
}

extension TrendMovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    /// section 4개
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionKind.allCases.count
    }
    /// section - item의 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sectionItems[section]
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let sectionKind = SectionKind(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionKind {
        case .movieInfo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieTitleCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieTitleCollectionViewCell else { return UICollectionViewCell() }
            cell.configureUI(movieDetail: movieInfo)
            return cell
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCastCell.identifier,
                for: indexPath
            ) as? TrendMovieCastCell else { return UICollectionViewCell() }
            
            cell.configureUI(cast: sectionDetails[sectionKind.rawValue - 1].actorInfo?[indexPath.item])
            return cell
        case .video:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
    }
}
