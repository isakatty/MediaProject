//
//  MoviesCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/24/24.
//

import UIKit

import Kingfisher

public final class MoviesCollectionViewCell: UICollectionViewCell {
    private let moviePosterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy() {
        contentView.addSubview(moviePosterImageView)
    }
    private func configureLayout() {
        moviePosterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    public func configureUI(path: String) {
        guard let imageUrl = URL(
            string: NetworkRequest.imageURL + path
        ) else { return }
        moviePosterImageView.kf.setImage(with: imageUrl)
    }
}
