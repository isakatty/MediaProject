//
//  RecommendTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/26/24.
//

import UIKit

public final class RecommendTableViewCell: UITableViewCell {
    static let id = "RecommendTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold19
        label.textColor = .black
        return label
    }()
    public lazy var similarCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout(
                cellWidthRatio: 0.28,
                cellHeightRatio: 1.0
            )
        )
        collection.register(
            MoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier
        )
        return collection
    }()
    
    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [titleLabel, similarCollectionView]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(20)
        }
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(contentView)
        }
    }
    public func configureUI(text: String?) {
        titleLabel.text = text
    }
    public func configureCollectionViewDimension(width: CGFloat) {
        let newLayout = collectionViewLayout(
            cellWidthRatio: width,
            cellHeightRatio: 1.0
        )
        if similarCollectionView.collectionViewLayout != newLayout {
            similarCollectionView.collectionViewLayout = newLayout
        }
    }
    private func collectionViewLayout(
        cellWidthRatio: CGFloat,
        cellHeightRatio: CGFloat
    ) -> UICollectionViewLayout {
        // item - item 자체를 뷰 꽉채움
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // group - group의 사이즈를 cell이 보여질 사이즈
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(cellWidthRatio),
            heightDimension: .fractionalHeight(cellHeightRatio)
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
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        layout.configuration = configuration

        return layout
    }
}
