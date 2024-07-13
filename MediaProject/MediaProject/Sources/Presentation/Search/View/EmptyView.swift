//
//  EmptyView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/29/24.
//

import UIKit

final class EmptyView: BaseView {
    
    private let searchImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "movieclapper.fill")?.withRenderingMode(.alwaysOriginal)
        image.tintColor = .black
        image.clipsToBounds = true
        return image
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "찾으시는 영화를 검색해주세요."
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    override func configureHierarchy() {
        [searchImage, searchLabel]
            .forEach { addSubview($0) }
    }
    
    func configureUI() {
        searchImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(searchImage.snp.width)
        }
        searchLabel.snp.makeConstraints { make in
            make.top.equalTo(searchImage.snp.bottom)
            make.horizontalEdges.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
