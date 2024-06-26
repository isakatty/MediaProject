//
//  ViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/4/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    let mainPosterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = 20
        return imgView
    }()
    let btnStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    let playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = Constant.Font.regular14
        titleContainer.foregroundColor = UIColor.black
        
        config.attributedTitle = AttributedString("재생", attributes: titleContainer)
        config.image = UIImage(systemName: "play.fill")?
            .withTintColor(.black)
            .withRenderingMode(.alwaysOriginal)
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.background.backgroundColor = UIColor.white
        config.cornerStyle = .large
        
        let btn = UIButton(configuration: config)
        return btn
    }()
    let favListButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = Constant.Font.regular13
        titleContainer.foregroundColor = UIColor.white
        config.attributedTitle = AttributedString(
            "내가 찜한 리스트",
            attributes: titleContainer
        )
        config.image = UIImage(systemName: "plus")?
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.background.backgroundColor = UIColor.darkGray
        config.cornerStyle = .large
        
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    let boomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "지금 뜨는 컨텐츠"
        return label
    }()
    let boomImageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    let boomFImageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 5
        image.backgroundColor = .cyan
        return image
    }()
    let boomSImageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 5
        image.backgroundColor = .black
        return image
    }()
    let boomTImageview: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 5
        image.backgroundColor = .blue
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }

    func configureHierarchy() {
        [mainPosterImageView, btnStackView,
         boomLabel, boomImageStackView]
            .forEach {
                view.addSubview($0)
            }
        [playButton, favListButton]
            .forEach {
                btnStackView.addArrangedSubview($0)
            }
        
        [boomFImageview, boomSImageview, boomTImageview]
            .forEach {
                boomImageStackView.addArrangedSubview($0)
            }
    }
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        mainPosterImageView.snp.makeConstraints { poster in
            poster.top.equalTo(safeArea)
            poster.leading.trailing.equalTo(safeArea).inset(30)
            poster.height.equalTo(450)
            poster.centerX.equalTo(safeArea)
        }
        btnStackView.snp.makeConstraints { stack in
            stack.leading.trailing.bottom.equalTo(mainPosterImageView).inset(15)
            stack.height.equalTo(40)
            stack.centerX.equalTo(mainPosterImageView)
        }
        boomLabel.snp.makeConstraints { label in
            label.top.equalTo(mainPosterImageView.snp.bottom).offset(10)
            label.leading.trailing.equalTo(safeArea).inset(15)
            label.height.equalTo(20)
            label.centerX.equalTo(safeArea.snp.centerX)
        }
        boomImageStackView.snp.makeConstraints { stack in
            stack.top.equalTo(boomLabel.snp.bottom).offset(10)
            stack.leading.trailing.equalTo(safeArea).inset(30)
            stack.bottom.equalTo(safeArea).inset(10)
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = .darkGray
        navigationItem.title = "ISAK님"
        
        [mainPosterImageView, boomFImageview,
         boomSImageview, boomTImageview]
            .forEach {
                $0.clipsToBounds = true
            }
        
        mainPosterImageView.image = UIImage(named: "노량")
        boomFImageview.image = UIImage(named: "범죄도시3")
        boomSImageview.image = UIImage(named: "오펜하이머")
        boomTImageview.image = UIImage(named: "콘크리트유토피아")
    }
    
}
