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
    
    /// 일단 이렇게 정의 . . ?
    var columnsInt: Int {
        switch self {
        case .movieInfo:
            return 1
        case .cast, .video:
            return 2
        }
    }
    
    var groupSize: [String: CGFloat] {
        switch self {
        case .movieInfo:
            return ["wid": 1.0, "hght": 0.5]
        case .cast:
            return ["wid": 2 / 9, "hght": 0.15]
        case .video:
            return ["wid": 1 / 3 , "hght": 0.15]
        }
    }
}

final class TrendMovieDetailViewController: BaseViewController {
    // 전View에서 받아올 값
    let movieInfo: MovieResponseDTO
    
    private var sectionItems: [Int] = .init(repeating: 4, count: 0)
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
        configureUI()
    }
    
    func configureHierarchy() {
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
    func configureUI() {
        // network 통신하고 item count 줘야함.
        sectionItems = [1,5,9]
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
        case .cast, .video:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
    }
}
