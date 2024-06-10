//
//  TrendMovieDetailActorInfoTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

import Kingfisher
import SnapKit

public class TrendMovieDetailActorInfoTableViewCell: UITableViewCell {
    private let actorImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .cyan
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    private let actorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    private let actorMovieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
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
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureHierarchy() {
        [actorImageView, actorNameLabel, actorMovieNameLabel]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        
        actorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(self.snp.height).multipliedBy(0.45 / 1.0)
            make.centerY.equalToSuperview()
        }
        actorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(30)
            make.centerY.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview()
            make.top.lessThanOrEqualToSuperview()
        }
        actorMovieNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(30)
            make.centerY.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    public func configureUI(
        cast: Cast?
    ) {
        guard let cast,
              let profile_path = cast.profile_path,
              let url = URL(string: PrivateKey.imageURL + profile_path)
        else { return }
        
        actorImageView.kf.setImage(with: url)
        actorNameLabel.text = cast.name
        actorMovieNameLabel.text = cast.character
    }
}
