//
//  TrendCollectionViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

final class TrendCollectionViewCell: UICollectionViewCell {
    
    /// numbering
    private let numberImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 4
        image.tintColor = .black
        image.backgroundColor = .white
        return image
    }()
    /// poster
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 4
        return image
    }()
    /// media title name
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.bold13
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [posterImage, titleLabel, numberImage]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 3
        
        posterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.Spacing.four.toCGFloat)
            make.leading.trailing.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
            make.bottom.equalToSuperview().inset(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(Constant.Spacing.four.toCGFloat)
            make.leading.trailing.equalTo(posterImage)
            make.bottom.equalToSuperview()
        }
        numberImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    func configureUI(
        posterPath: String,
        numberIndex: Int,
        titleName: String
    ) {
        let number = String(format: "%02d", numberIndex)
        numberImage.image = UIImage(systemName: number + ".square.fill")
        titleLabel.text = titleName
        guard let url = URL(string: NetworkRequest.imageBaseURL + posterPath) else {
            print("url 오류")
            return
        }
        NetworkService.shared.callImageData(url: url) { [weak self] data in
            guard let self else { return }
            DispatchQueue.main.async {
                self.posterImage.image = data
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage.image = nil
    }
}
