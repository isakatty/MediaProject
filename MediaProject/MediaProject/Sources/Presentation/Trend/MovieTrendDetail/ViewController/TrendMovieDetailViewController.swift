//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

final class TrendMovieDetailViewController: BaseViewController {
    let viewModel: TrendDetailViewModel
    
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
        collectionView.register(
            TrendTitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrendTitleSupplementaryView.id
        )
        return collectionView
    }()
    
    init(viewModel: TrendDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(viewTitle: viewModel.movieInfo.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.catchedDataFetch.bind { isFinished in
            if isFinished {
                self.detailCollectionView.reloadData()
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
            self.detailCollectionView.reloadSections(IndexSet(integer: 0))
        }
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
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
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
        section.boundarySupplementaryItems = [self.createSupplementaryHeaderItem()]
        
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

extension TrendMovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    /// section 4개
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TrendDetailSectionKind.allCases.count
    }
    /// section - item의 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.outputSectionItems.value[section]
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let sectionKind = TrendDetailSectionKind(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch sectionKind {
        case .movieInfo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieTitleCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieTitleCollectionViewCell else {
                return UICollectionViewCell()
            }
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
                movieDetail: viewModel.movieInfo,
                isFav: viewModel.outputFavoriteMovie.value
            )
            return cell
            
            // TODO: SectionData로 묶어서 처리하지 않고, 각각의 output으로 둔다면 filter 처리하지 않아도 되지 않을까 ?
            // output의 형태 변경
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCastCell.identifier,
                for: indexPath
            ) as? TrendMovieCastCell else {
                return UICollectionViewCell()
            }
            if viewModel.catchedDataFetch.value {
                let castData = viewModel.outputSectionDatas.value.first(where: { $0.actorInfo != nil })?.actorInfo?[indexPath.item]
                cell.configureUI(cast: castData)
            }
            return cell

        case .poster:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            if viewModel.catchedDataFetch.value {
                let posterData = viewModel.outputSectionDatas.value.first(
                    where: { $0.poster != nil }
                )?.poster?[indexPath.item].file_path
                cell.configureUI(path: posterData, indexPath: indexPath.item)
            }
            return cell

        case .similar:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendMovieCollectionViewCell.identifier,
                for: indexPath
            ) as? TrendMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            if viewModel.catchedDataFetch.value {
                let similarData = viewModel.outputSectionDatas.value.first(
                    where: { $0.similar != nil }
                )?.similar?[indexPath.item].poster_path
                cell.configureUI(path: similarData, indexPath: indexPath.item)
            }
            return cell
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrendTitleSupplementaryView.id,
            for: indexPath
        ) as? TrendTitleSupplementaryView,
              let sectionKind = TrendDetailSectionKind(rawValue: indexPath.section)
        else { return UICollectionReusableView() }
        
        switch sectionKind {
        case .movieInfo:
            // 없애고 싶은데..
            print("")
        case .cast, .poster, .similar:
            headerView.configureUI(headerTitle: sectionKind.toTitle)
        }
        return headerView
    }
}
