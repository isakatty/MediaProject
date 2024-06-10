//
//  TrendMovieDetailSectionView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/11/24.
//

import UIKit

import SnapKit

public class TrendMovieDetailSectionView: UITableViewHeaderFooterView {

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
        addSubview(sectionLabel)
    }
    private func configureLayout() {
        sectionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
        }
    }
    public func configureUI(
        with sectionText: String
    ) {
        sectionLabel.text = sectionText
    }
    
}
