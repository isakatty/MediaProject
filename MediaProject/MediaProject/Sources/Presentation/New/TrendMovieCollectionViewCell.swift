//
//  TrendMovieCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

import Kingfisher

final class TrendMovieCollectionViewCell: BaseCollectionViewCell {
    private let sectionName: UILabel = {
        let label = UILabel()
        label.text = "영화 Poster"
        label.textColor = UIColor.black
        label.font = Constant.Font.bold17
        return label
    }()
    
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
        [sectionName, posterImage]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        sectionName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(17)
        }
        
        posterImage.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(posterImage.snp.width).multipliedBy(0.6)
        }
    }
    func configureUI(path: String?, indexPath: Int, similarTitle: String?) {
        guard let path = path,
              let imagURL = URL(string: NetworkRequest.imageBaseURL + path)
        else { return }
//        posterImage.image = UIImage()
        posterImage.kf.setImage(with: imagURL)
        sectionName.text = similarTitle
        
        if indexPath > 0 {
            sectionName.isHidden = true
        }
    }
    func configureLayout(isSimilar: Bool, heightRatio: CGFloat) {
        posterImage.snp.removeConstraints()
        
        posterImage.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(posterImage.snp.width).multipliedBy(isSimilar ? heightRatio : 0.6)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
        print(#function)
    }
}
