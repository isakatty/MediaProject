//
//  TrendMovieDetailHeaderView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

public class TrendMovieDetailHeaderView: UITableViewHeaderFooterView {
    private let backPosterView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        return label
    }()
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [backPosterView, sectionLabel]
            .forEach { contentView.addSubview($0) }
        [posterView, movieTitleLabel]
            .forEach { backPosterView.addSubview($0) }
        
    }
    private func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(240)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        backPosterView.snp.makeConstraints { make in
            make.top.leading.trailing.centerX.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.55)
        }
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(24)
        }
        posterView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(contentView.snp.height).multipliedBy(0.45 / 1.0)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.8)
        }
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(backPosterView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    public func configureUI(
        with movieInfo: MovieInfo,
        with sectionText: String
    ) {
        guard let backPosterImage = URL(string: Constant.Endpoint.imageURL + movieInfo.backdrop_path),
              let posterImage = URL(string: Constant.Endpoint.imageURL + movieInfo.poster_path)
        else { return }
        backPosterView.kf.setImage(with: backPosterImage)
        posterView.kf.setImage(with: posterImage)
        movieTitleLabel.text = movieInfo.title
        sectionLabel.text = sectionText
    }
}
