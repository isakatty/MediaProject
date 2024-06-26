//
//  JoinViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/4/24.
//

import UIKit

import SnapKit

class JoinViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 30,
            weight: .heavy
        )
        label.textColor = .red
        label.textAlignment = .center
        label.text = "ISAKFLIX"
        return label
    }()
    let tfStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    lazy var emailTF: UITextField = {
        let tf = UITextField()
        configureTextField(tf: tf, placeholder: "이메일 주소 또는 전화번호")
        return tf
    }()
    lazy var passwordTF: UITextField = {
        let tf = UITextField()
        configureTextField(tf: tf, placeholder: "비밀번호")
        return tf
    }()
    lazy var nicknameTF: UITextField = {
        let tf = UITextField()
        configureTextField(tf: tf, placeholder: "닉네임")
        return tf
    }()
    lazy var locationTF: UITextField = {
        let tf = UITextField()
        configureTextField(tf: tf, placeholder: "위치")
        return tf
    }()
    lazy var codeTF: UITextField = {
        let tf = UITextField()
        configureTextField(tf: tf, placeholder: "추천 코드 입력")
        return tf
    }()
    let joinButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.addTarget(
            JoinViewController.self,
            action: #selector(joinedBtnTapped),
            for: .touchUpInside
        )
        return btn
    }()
    let addInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 정보 입력"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let switchButton: UISwitch = {
        let btn = UISwitch()
        btn.tintColor = .systemOrange
        btn.isOn = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureTextField(
        tf: UITextField,
        placeholder: String
    ) {
        tf.backgroundColor = .darkGray
        tf.placeholder = placeholder
        tf.textColor = .white
        tf.borderStyle = .roundedRect
        tf.font = .systemFont(ofSize: 13)
        tf.setPlaceholder(color: .white)
    }

    func configureHierarchy() {
        [titleLabel, tfStackView, joinButton,
         addInfoLabel, switchButton]
            .forEach {
                view.addSubview($0)
            }
        [emailTF, passwordTF, nicknameTF, locationTF, codeTF]
            .forEach { tfStackView.addArrangedSubview($0) }
    }
    
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints { title in
            title.top.equalTo(safeArea).offset(30)
            title.width.greaterThanOrEqualTo(30)
            title.centerX.equalTo(safeArea)
        }
        
        tfStackView.snp.makeConstraints { stack in
            stack.top.equalTo(titleLabel.snp.bottom).offset(70)
            stack.leading.trailing.equalTo(safeArea).inset(35)
            stack.height.equalTo(300)
        }
        
        joinButton.snp.makeConstraints { btn in
            btn.top.equalTo(tfStackView.snp.bottom).offset(20)
            btn.leading.trailing.equalTo(safeArea).inset(35)
            btn.height.equalTo(50)
        }
        
        addInfoLabel.snp.makeConstraints { label in
            label.top.equalTo(joinButton.snp.bottom).offset(30)
            label.leading.equalTo(safeArea).inset(30)
            label.trailing.lessThanOrEqualTo(switchButton.snp.leading)
            label.height.equalTo(20)
        }
        
        switchButton.snp.makeConstraints { btn in
            btn.trailing.equalTo(safeArea).inset(30)
            btn.top.equalTo(joinButton.snp.bottom).offset(30)
            btn.height.equalTo(20)
            btn.width.equalTo(switchButton.snp.height).multipliedBy(2)
        }
    }
    func configureUI() {
        view.backgroundColor = .black
        
        
    }
    
    @objc func joinedBtnTapped() {
    }
}
