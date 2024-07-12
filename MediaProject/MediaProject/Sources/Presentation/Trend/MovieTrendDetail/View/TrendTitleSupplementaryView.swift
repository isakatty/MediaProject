//
//  TrendTitleSupplementaryView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/12/24.
//

import UIKit

final class TrendTitleSupplementaryView: UICollectionReusableView {
    static let id = "TrendTitleSupplementaryView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold15
        label.textColor = UIColor.black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    private func configureLayout() {
        backgroundColor = .systemBackground
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
                .inset(Constant.Spacing.four.toCGFloat)
        }
    }
    func configureUI(headerTitle: String) {
        titleLabel.text = headerTitle
    }
}
