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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
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
        
        actorImageView.image = nil
        [actorNameLabel, actorMovieNameLabel]
            .forEach { $0.text = nil}
    }
    
    private func configureHierarchy() {
        [actorImageView, actorNameLabel, actorMovieNameLabel]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        actorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(80)
            make.width.equalToSuperview().multipliedBy(0.2 / 1.0)
            make.centerY.equalToSuperview()
        }
        actorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(30)
            make.centerY.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        actorMovieNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(30)
            make.centerY.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
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