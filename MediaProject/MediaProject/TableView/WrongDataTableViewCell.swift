//
//  WrongDataTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

import SnapKit

class WrongDataTableViewCell: UITableViewCell {
    let errorLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "20240602 형태로 검색해주세요."
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
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
    
    func configureHierarchy() {
        contentView.addSubview(errorLabel)
    }
    func configureLayout() {
        backgroundColor = .clear
        
        errorLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
