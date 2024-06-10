//
//  TrendMovieDetailHeaderView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

public class TrendMovieDetailHeaderView: UIView {
    private let backPosterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [backPosterView, posterView, movieTitleLabel]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        backPosterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(24)
        }
        posterView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(self.snp.height).multipliedBy(0.45 / 1.0)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    public func configureUI(
        with movieInfo: MovieInfo
    ) {
        guard let backPosterImage = URL(string: PrivateKey.imageURL + movieInfo.backdrop_path),
        let posterImage = URL(string: PrivateKey.imageURL + movieInfo.poster_path)
        else { return }
        backPosterView.kf.setImage(with: backPosterImage)
        posterView.kf.setImage(with: posterImage)
        movieTitleLabel.text = movieInfo.title
    }
}