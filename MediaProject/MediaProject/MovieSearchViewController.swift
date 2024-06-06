//
//  MovieSearchViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

import SnapKit

class MovieSearchViewController: UIViewController {
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "날짜를 입력하세요"
        tf.textColor = .white
        return tf
    }()
    let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("검색", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var movieListTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 60
        table.register(
            SearchMovieListTableViewCell.self,
            forCellReuseIdentifier: SearchMovieListTableViewCell.identifier
        )
        table.backgroundColor = .black
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() {
        [searchTextField, seperateBar, searchButton, movieListTableView]
            .forEach { view.addSubview($0) }
    }
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(30)
            make.leading.equalTo(safeArea).inset(15)
            make.height.equalTo(20)
            make.trailing.equalTo(searchButton.snp.leading).inset(-15)
        }
        seperateBar.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(searchTextField)
            make.height.equalTo(3)
        }
        searchButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea).inset(15)
            make.bottom.equalTo(seperateBar.snp.bottom)
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
        movieListTableView.snp.makeConstraints { make in
            make.top.equalTo(seperateBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    func configureUI() {
        view.backgroundColor = .black
        
    }
}

extension MovieSearchViewController
: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = movieListTableView.dequeueReusableCell(
            withIdentifier: SearchMovieListTableViewCell.identifier,
            for: indexPath
        ) as? SearchMovieListTableViewCell else { return UITableViewCell() }
        
        cell.configureUI(number: "1", movieName: "얌얌이", openDt: "2024-06-02")
        
        return cell
    }
}
