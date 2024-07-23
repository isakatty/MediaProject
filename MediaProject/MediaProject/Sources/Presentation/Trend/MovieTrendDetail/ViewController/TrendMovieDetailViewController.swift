//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

enum TrendDetailSectionItem: Hashable {
    case detail(MovieResponseDTO, Bool)
    case cast(CastResponseDTO)
    case poster(PosterPathResponseDTO)
    case similar(SimilarDTO)
}

final class TrendMovieDetailViewController: BaseViewController {
    let viewModel: TrendDetailViewModel
    private var dataSource: UICollectionViewDiffableDataSource<TrendDetailSectionKind, TrendDetailSectionItem>!
    
    private lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout()
        )
        collectionView.delegate = self
        return collectionView
    }()
    
    init(viewModel: TrendDetailViewModel) {
        self.viewModel = viewModel
        print("Detail VC init")
        super.init(viewTitle: viewModel.movieInfo.title)
    }
    
    deinit {
        print(#file, "Detail Trend VC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        createDataSource()
        updateSnapshot()
    }
    
    private func bindData() {
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.catchedDataFetch.bind { [weak self] isFinished in
            guard let self else { return }
            if isFinished {
                self.updateSnapshot()
            }
        }
        viewModel.outputVideoInfo.bind { [weak self] videoName, urlString in
            guard let self else { return }
            guard let urlString,
                  !urlString.isEmpty
            else { return }
            
            if urlString != "There's no first video info" {
                let vc = VideoWebViewController(
                    viewModel: VideoWebViewModel(urlString: urlString),
                    viewTitle: videoName ?? ""
                )
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // TODO: Toast 띄우기
                showToast(message: "해당 영화의 영화 트레일러가 준비중입니다.")
            }
        }
        viewModel.outputFavoriteMovie.bind { [weak self] _ in
            guard let self else { return }
            self.updateSnapshot()
        }
    }
    
    private func createDataSource() {
        let detailCell = UICollectionView.CellRegistration<TrendMovieTitleCollectionViewCell, (MovieResponseDTO, Bool)> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.clearBtn.addTarget(
                self,
                action: #selector(videoBtnTapped),
                for: .touchUpInside
            )
            cell.favBtn.addTarget(
                self,
                action: #selector(favBtnTapped),
                for: .touchUpInside
            )
            cell.configureUI(
                movieDetail: itemIdentifier.0,
                isFav: itemIdentifier.1
            )
        }
        let castCell = UICollectionView.CellRegistration<TrendMovieCastCell, CastResponseDTO> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            
            if viewModel.catchedDataFetch.value {
                cell.configureUI(cast: itemIdentifier)
            }
        }
        let posterCell = UICollectionView.CellRegistration<TrendMovieCollectionViewCell,PosterPathResponseDTO> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            if viewModel.catchedDataFetch.value {
                cell.configureUI(path: itemIdentifier.file_path)
            }
        }
        let similarCell = UICollectionView.CellRegistration<TrendMovieCollectionViewCell,SimilarDTO> { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            if viewModel.catchedDataFetch.value {
                cell.configureUI(path: itemIdentifier.poster_path)
            }
        }
        let sectionHeader = UICollectionView.SupplementaryRegistration<TrendTitleSupplementaryView> (elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.configureUI(headerTitle: TrendDetailSectionKind.allCases[indexPath.section].toTitle)
        }
        
        dataSource = UICollectionViewDiffableDataSource<TrendDetailSectionKind, TrendDetailSectionItem>(
            collectionView: detailCollectionView,
            cellProvider: { (collectionView, indexPath, itemIdentifier) in
                switch itemIdentifier {
                case .detail(let movieDetail, let isFav):
                    return collectionView.dequeueConfiguredReusableCell(using: detailCell, for: indexPath, item: (movieDetail, isFav))
                case .cast(let castDetail):
                    return collectionView.dequeueConfiguredReusableCell(using: castCell, for: indexPath, item: castDetail)
                case .poster(let posterDetail):
                    return collectionView.dequeueConfiguredReusableCell(using: posterCell, for: indexPath, item: posterDetail)
                case .similar(let similarDetail):
                    return collectionView.dequeueConfiguredReusableCell(using: similarCell, for: indexPath, item: similarDetail)
                }
            }
        )
        dataSource.supplementaryViewProvider = { [weak self] view, elementKind, indexPath in
            guard let self else { return UICollectionReusableView() }
            return self.detailCollectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeader,
                for: indexPath
            )
        }
    }
    private func updateSnapshot() {
        let castItems = viewModel.outputCastData.value.map { TrendDetailSectionItem.cast($0) }
        let posterItems = viewModel.outputPosterData.value.map { TrendDetailSectionItem.poster($0) }
        let similarItems = viewModel.outputSimilarData.value.map { TrendDetailSectionItem.similar($0) }
        var snapshot = NSDiffableDataSourceSnapshot<TrendDetailSectionKind,TrendDetailSectionItem>()
        snapshot.appendSections(TrendDetailSectionKind.allCases)
        snapshot.appendItems([TrendDetailSectionItem.detail(viewModel.movieInfo, viewModel.outputFavoriteMovie.value)], toSection: .movieInfo)
        snapshot.appendItems(castItems, toSection: .cast)
        snapshot.appendItems(posterItems, toSection: .poster)
        snapshot.appendItems(similarItems, toSection: .similar)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func configureHierarchy() {
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
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            guard let sectionKind = TrendDetailSectionKind(rawValue: sectionIndex) else { return nil }
            switch sectionKind {
            case .movieInfo:
                return self.createVerticalSection(
                    widthRatio: sectionKind.groupSize["wid"]!,
                    heightRatio: sectionKind.groupSize["hght"]!
                )
            case .cast, .poster, .similar:
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
        section.boundarySupplementaryItems = [createSupplementaryHeaderItem()]
        
        return section
    }
    private func createSupplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(50)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    @objc private func videoBtnTapped(_ sender: UIButton) {
        print(sender.tag)
        // webView load
        viewModel.inputVideoBtnTrigger.value = sender.tag
    }
    @objc private func favBtnTapped(_ sender: UIButton) {
        // viewModel input trigger - sender.tag
        print(sender.tag)
        viewModel.inputFavBtnTrigger.value = sender.tag
    }
}

extension TrendMovieDetailViewController: UICollectionViewDelegate {
    
}
