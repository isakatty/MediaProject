//
//  MoviePosterView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/14/24.
//

import UIKit

import Kingfisher

final class MoviePosterView: UIView {
    private let poster: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "movieclapper")
        view.tintColor = .black
        return view
    }()
    let clearBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        return btn
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
        [poster, clearBtn]
            .forEach { addSubview($0) }
    }
    private func configureLayout() {
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        
        poster.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        clearBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(posterPath: String) {
        //이미지 kingfisher
        let baseURL = NetworkRequest.imageBaseURL + posterPath
        guard let url = URL(string: baseURL) else { return }
        poster.kf.setImage(with: url)
    }
}
