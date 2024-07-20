//
//  TrendMovieCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

import Kingfisher

final class TrendMovieCollectionViewCell: BaseCollectionViewCell {
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [posterImage]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configureUI(path: String?) {
        guard let path = path,
              let imagURL = URL(string: NetworkRequest.imageBaseURL + path)
        else { return }
//        posterImage.image = UIImage()
        posterImage.kf.setImage(with: imagURL)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
    }
}
