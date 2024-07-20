//
//  CalendarLabelView.swift
//  MediaProject
//
//  Created by Jisoo Ham on 7/13/24.
//

import UIKit

final class CalendarLabelView: BaseView {
    private let posterImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "plus")
        view.tintColor = .darkGray
        view.clipsToBounds = true
        return view
    }()
    private let movieTitleLabel: PaddingLabel = {
        let spacing = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: spacing, left: spacing, bottom: spacing, right: spacing))
        label.font = Constant.Font.bold17
        label.textColor = UIColor.black
        label.text = " "
        label.textAlignment = .center
        return label
    }()
    private let memoTitleLabel: PaddingLabel = {
        let spacing = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: spacing, left: spacing, bottom: spacing, right: spacing))
        label.font = Constant.Font.bold13
        label.textColor = UIColor.darkGray
        label.text = "영화 메모를 작성해보세요 !"
        label.textAlignment = .left
        return label
    }()
    private let wroteDateLabel: PaddingLabel = {
        let spacing = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: spacing, left: spacing, bottom: spacing, right: spacing))
        label.font = Constant.Font.bold13
        label.textColor = UIColor.darkGray
        label.textAlignment = .right
        return label
    }()
    private let tagLabel: PaddingLabel = {
        let spacing = Constant.Spacing.eight.toCGFloat
        let label = PaddingLabel(inset: .init(top: spacing, left: spacing, bottom: spacing, right: spacing))
        label.font = Constant.Font.regular13
        label.textColor = UIColor.blue
        label.textAlignment = .left
        return label
    }()
    let clearBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 15
    }
    
    override func configureHierarchy() {
        [posterImgView, movieTitleLabel, memoTitleLabel, wroteDateLabel, tagLabel, clearBtn]
            .forEach { addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        posterImgView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
            make.width.equalTo(posterImgView.snp.height).multipliedBy(0.6)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
            make.leading.equalTo(posterImgView.snp.trailing)
        }
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom)
            make.leading.equalTo(posterImgView.snp.trailing)
            make.height.equalTo(20)
        }
        wroteDateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.leading.equalTo(memoTitleLabel.snp.trailing)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(100)
        }
        tagLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImgView.snp.trailing)
            make.bottom.trailing.equalToSuperview().inset(Constant.Spacing.eight.toCGFloat)
        }
        clearBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(
        posterPath: String,
        movie: String,
        memoTitle: String,
        wroteDate: Date,
        tag: String?
    ) {
        movieTitleLabel.textAlignment = .left
        movieTitleLabel.text = movie
        memoTitleLabel.text = memoTitle
        wroteDateLabel.text = wroteDate.toString
        tagLabel.text = tag
        
        let totalURLStr = NetworkRequest.imageBaseURL + posterPath
        guard let url = URL(string: totalURLStr) else { return }
        
        NetworkService.shared.callImageData(url: url) { [weak self] image in
            guard let self else { return }
            self.posterImgView.image = image
        }
    }
    
    func configureNoMemo() {
        posterImgView.image = UIImage(systemName: "plus")
        posterImgView.tintColor = .darkGray
        memoTitleLabel.text = ""
        movieTitleLabel.text = "영화 메모를 작성해보세요 !"
        wroteDateLabel.text = ""
        tagLabel.text = ""
    }
}
