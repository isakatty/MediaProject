//
//  RecommendTableHeaderView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import UIKit

public final class RecommendTableHeaderView: UITableViewHeaderFooterView {
    
    private lazy var movieLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold21
        label.textColor = UIColor.black
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
        contentView.addSubview(movieLabel)
    }
    private func configureLayout() {
        movieLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.07)
        }
    }
    
    public func configureUI(movieTitle: String) {
        movieLabel.text = movieTitle
    }
}
