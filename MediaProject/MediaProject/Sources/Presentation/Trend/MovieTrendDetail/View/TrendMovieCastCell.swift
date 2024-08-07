//
//  TrendMovieCastCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 7/1/24.
//

import UIKit

final class TrendMovieCastCell: BaseCollectionViewCell {
    let profileImgView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .cyan
        return image
    }()
    private let actorName: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular13
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    private let castName: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.regular13
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [profileImgView, actorName, castName]
            .forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        profileImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(profileImgView.snp.width)
        }
        actorName.snp.makeConstraints { make in
            make.top.equalTo(profileImgView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        castName.snp.makeConstraints { make in
            make.top.equalTo(actorName.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    func configureUI(cast: CastResponseDTO?) {
        guard let cast = cast else {
            print("cast nil")
            return
        }
        guard let imgURL = URL(string: NetworkRequest.imageBaseURL + cast.profile_path) else {
            print("이미지 url Error")
            return
        }
        
        NetworkService.shared.callImageData(url: imgURL) { [weak self] image in
            guard let self else { return }
            self.profileImgView.image = image
        }
        
        actorName.text = cast.name
        castName.text = cast.character
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.profileImgView.layer.cornerRadius = self.profileImgView.bounds.width / 2
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImgView.image = nil
    }
}
