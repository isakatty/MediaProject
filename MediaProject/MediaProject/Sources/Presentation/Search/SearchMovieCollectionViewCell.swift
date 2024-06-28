//
//  SearchMovieCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

final class SearchMovieCollectionViewCell: UICollectionViewCell {
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(movieImageView)
    }
    private func configureLayout() {
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configureUI(
        with imageString: String
    ) {
        let baseURL = NetworkRequest.imageURL
        guard let url = URL(string: baseURL + imageString) else { return }
        
        movieImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
}
