//
//  NewTrendViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

import SnapKit

enum Trends: String, CaseIterable {
    case movie = "Movie"
}

final class NewTrendViewController: BaseViewController {
    private let viewModel = TrendViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Trends, MovieResponseDTO>!
    
    private lazy var trendCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionLayout()
        )
        collection.delegate = self
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBtn()
        bindData()
        createDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: .favoritesUpdated, object: nil)
    }
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        viewModel.outputTrendMovie.bind { [weak self] _ in
            guard let self else { return }
            self.updateSnapshot()
        }
        viewModel.outputMovieResponse.bind { [weak self] movieInfo in
            guard let self, let movieInfo else { return }
            let vc = TrendMovieDetailViewController(viewModel: TrendDetailViewModel(movieInfo:  movieInfo))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func configureHierarchy() {
        [trendCollectionView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        trendCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    private func configureBtn() {
        let first = UIAction(title: "오늘의 트렌드") { [weak self] action in
            guard let self else { return }
            self.viewModel.inputViewDidLoad.value = ()
        }
        let second = UIAction(title: "즐겨찾기 목록") { [weak self] action in
            guard let self else { return }
            self.viewModel.inputFilterFavsTrigger.value = ()
        }
        let menus: UIMenu = UIMenu(title: "Sort", children: [first, second])
        navigationItem.rightBarButtonItem = .init(title: "필터", menu: menus)
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
    private func createDataSource() {
        let movieRegistration = UICollectionView.CellRegistration<
            TrendCollectionViewCell,
            MovieResponseDTO
        > { cell, indexPath, itemIdentifier in
            cell.configureUI(
                posterPath: itemIdentifier.poster_path,
                numberIndex: indexPath.item + 1,
                titleName: itemIdentifier.title
            )
        }
        dataSource = .init(
            collectionView: trendCollectionView,
            cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: movieRegistration,
                    for: indexPath,
                    item: itemIdentifier
                ) as TrendCollectionViewCell
                
                return cell
            }
        )
    }
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Trends, MovieResponseDTO>()
        snapshot.appendSections(Trends.allCases)
        snapshot.appendItems(viewModel.outputTrendMovie.value.media, toSection: .movie)
        dataSource.apply(snapshot)
    }
    
    @objc private func favoritesUpdated() {
        viewModel.changedFavsTrigger.value = ()
    }
}

extension NewTrendViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        viewModel.inputMovieSelectedTrigger.value = indexPath.item
    }
}
