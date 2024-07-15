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
    private let viewModel = TrendViewModel()
    
    private lazy var segments: UISegmentedControl = {
        let segmentItems = Trends.allCases.map { $0.description }
        let segments = UISegmentedControl(items: segmentItems)
        segments.selectedSegmentIndex = Trends.movie.rawValue
        segments.addTarget(self, action: #selector(segTapped), for: .valueChanged)
        return segments
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
        
        bindData()
    }
    private func bindData() {
        viewModel.inputSegTrigger.value = segments.selectedSegmentIndex
        viewModel.outputTrendMovie.bind { [weak self] _ in
            guard let self else { return }
            self.trendCollectionView.reloadData()
        }
        viewModel.outputTrendTV.bind { [weak self] _ in
            guard let self else { return }
            self.trendCollectionView.reloadData()
        }
        viewModel.outputMovieResponse.bind { [weak self] movieInfo in
            guard let self, let movieInfo else { return }
            let vc = TrendMovieDetailViewController(viewModel: TrendDetailViewModel(movieInfo:  movieInfo))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func configureHierarchy() {
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
        viewModel.inputSegTrigger.value = sender.selectedSegmentIndex
    }
}

extension NewTrendViewController
: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.outputListCount.value
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendCollectionViewCell.identifier,
            for: indexPath
        ) as? TrendCollectionViewCell,
              let trend = Trends(rawValue: viewModel.inputSegTrigger.value)
        else { return UICollectionViewCell() }
        
        switch trend {
        case .movie:
            if viewModel.outputTrendMovie.value.media.count > 1 {
                let movies = viewModel.outputTrendMovie.value.media[indexPath.item]
                cell.configureUI(
                    posterPath: movies.poster_path,
                    numberIndex: indexPath.item + 1,
                    titleName: movies.title
                )
            }
        case .tv:
            if viewModel.outputTrendTV.value.media.count > 1 {
                let tvs = viewModel.outputTrendTV.value.media[indexPath.item]
                cell.configureUI(
                    posterPath: tvs.poster_path,
                    numberIndex: indexPath.item + 1,
                    titleName: tvs.name
                )
            }
        }
        
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let trend = Trends(rawValue: segments.selectedSegmentIndex) else { return }
        
        switch trend {
        case .movie:
            viewModel.inputMovieSelectedTrigger.value = indexPath.item
        case .tv:
            print("아무일도 일어나지 않음")
        }
    }
}
