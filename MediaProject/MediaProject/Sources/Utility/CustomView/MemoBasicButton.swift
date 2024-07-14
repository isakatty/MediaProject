//
//  MemoBasicButton.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

final class MemoBasicButton: UIButton {
    
    private let btnTitle: PaddingLabel = {
        let verticalPadding: CGFloat = Constant.Spacing.four.toCGFloat
        let horizontalPadding: CGFloat = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = Constant.Font.bold15
        label.text = "영화 관람 날짜"
        return label
    }()
    private let resultLabel: PaddingLabel = {
        let verticalPadding: CGFloat = Constant.Spacing.four.toCGFloat
        let horizontalPadding: CGFloat = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = Constant.Font.regular15
        return label
    }()
    
    private let chevronImg: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = UIColor.lightGray
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        btnTitle.text = title
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [btnTitle, resultLabel, chevronImg]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        
        btnTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
        }
        
        chevronImg.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
            make.width.equalTo(30)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(btnTitle.snp.trailing)
            make.trailing.equalTo(chevronImg.snp.leading).offset(-Constant.Spacing.eight.toCGFloat)
        }
    }
    func configureUI(detail: String?) {
//        btnTitle.text = title
        resultLabel.text = detail
        resultLabel.textColor = .darkGray
    }
    
}
