//
//  TrendTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import SnapKit
import Kingfisher

final class TrendTableViewCell: UITableViewCell {
    
    // 이미지, movie title, 평점, seperate bar, 자세히 보기
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let squareView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
        return view
    }()
    private let imagePosterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    private let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "자세히 보기"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    private let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal)
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        return view
    }()
    
    override init(
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
        [releaseDateLabel, squareView]
            .forEach { contentView.addSubview($0) }
        [imagePosterImage, infoView]
            .forEach { squareView.addSubview($0) }
        [movieTitleLabel, seperateBar, detailLabel, chevronImageView]
            .forEach { infoView.addSubview($0) }
    }
    private func configureLayout() {
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(20)
        }
        squareView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        imagePosterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.top.equalTo(imagePosterImage.snp.top).offset(180)
            make.leading.trailing.equalTo(squareView)
            make.bottom.equalToSuperview()
        }
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        seperateBar.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        detailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(seperateBar.snp.bottom).offset(16)
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading)
            make.bottom.equalToSuperview().inset(8)
        }
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(seperateBar.snp.bottom).offset(16)
            make.width.equalTo(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureUI(
        movieInfo: MovieInfo
    ) {
        guard let imageUrl = URL(string: NetworkRequest.imageBaseURL + movieInfo.backdrop_path) else { return }
        imagePosterImage.kf.setImage(with: imageUrl)
        movieTitleLabel.text = movieInfo.title
        releaseDateLabel.text = movieInfo.release_date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the cell's content and layout states
        releaseDateLabel.text = nil
        imagePosterImage.image = nil
        movieTitleLabel.text = nil
        detailLabel.text = "자세히 보기"
        chevronImageView.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal)
    }
}
