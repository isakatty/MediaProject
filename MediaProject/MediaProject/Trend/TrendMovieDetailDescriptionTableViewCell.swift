//
//  TrendMovieDetailDescriptionTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

public class TrendMovieDetailDescriptionTableViewCell: UITableViewCell {
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = .zero
        label.textAlignment = .center
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
        [descriptionLabel]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(-20)
        }
    }
    public func configureUI(
        descriptionText: String
    ) {
        descriptionLabel.text = descriptionText
    }
}
