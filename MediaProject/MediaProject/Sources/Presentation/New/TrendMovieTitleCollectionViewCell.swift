//
//  TrendMovieTitleCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

import Kingfisher

final class TrendMovieTitleCollectionViewCell: BaseCollectionViewCell {
    private let backPosterImg: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    private let halfView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    private let posterContainerView: UIView = {
        let view = UIView()
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        return view
    }()
    private let posterImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        return img
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = .black
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular13
        label.textColor = .black
        return label
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular14
        label.textColor = .lightGray
        label.numberOfLines = .zero
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [backPosterImg, halfView, posterContainerView]
            .forEach { contentView.addSubview($0) }
        [titleLabel, dateLabel, overviewLabel]
            .forEach { halfView.addSubview($0) }
        posterContainerView.addSubview(posterImg)
    }
    private func configureLayout() {
        backPosterImg.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(backPosterImg.snp.width).multipliedBy(0.6)
        }
        halfView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(halfView.snp.width).multipliedBy(0.5)
        }
        posterContainerView.snp.makeConstraints { make in
            make.top.equalTo(halfView.snp.top).offset(-70)
            make.leading.equalToSuperview().inset(16)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(posterImg.snp.width).multipliedBy(1.4)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(posterImg.snp.trailing).inset(-12)
            make.trailing.equalToSuperview()
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.15)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(12)
            make.leading.trailing.height.equalTo(titleLabel)
        }
        overviewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(posterImg.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        posterImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(movieDetail: MovieResponseDTO) {
        guard let backImgURL = URL(string: NetworkRequest.imageBaseURL + movieDetail.backdrop_path),
              let posterImgURL = URL(string: NetworkRequest.imageBaseURL + movieDetail.poster_path)
        else { 
            print("url 에러")
            return
        }
        
        backPosterImg.kf.setImage(with: backImgURL)
        posterImg.kf.setImage(with: posterImgURL)
        titleLabel.text = movieDetail.title
        dateLabel.text = movieDetail.releaseDate
        overviewLabel.text = movieDetail.overView
    }
}
