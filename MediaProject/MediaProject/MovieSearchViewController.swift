//
//  MovieSearchViewController.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

import Alamofire
import SnapKit

class MovieSearchViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "날짜를 입력하세요"
        tf.textColor = .white
        tf.delegate = self
        return tf
    }()
    private let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("검색", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(
            self,
            action: #selector(searchBtnTapped)
            , for: .touchUpInside
        )
        return btn
    }()
    private lazy var movieListTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 60
        table.register(
            SearchMovieListTableViewCell.self,
            forCellReuseIdentifier: SearchMovieListTableViewCell.identifier
        )
        table.register(
            WrongDataTableViewCell.self,
            forCellReuseIdentifier: WrongDataTableViewCell.identifier
        )
        table.backgroundColor = .black
        return table
    }()
    private var searchMovieList = [DailyBoxOfficeList]() {
        didSet {
            movieListTableView.reloadData()
        }
    }
    private var isNetwork: Bool = false
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    private func configureHierarchy() {
        [searchTextField, seperateBar, searchButton, movieListTableView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
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
    private func configureUI() {
        view.backgroundColor = .black
    }
    private func networking(date: String) {
        let movieURL = PrivateKey.url + date
        
        AF.request(movieURL).responseDecodable(
            of: Movie.self
        ) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let movie):
                isNetwork = !isNetwork
                self.searchMovieList = movie.boxOfficeResult.dailyBoxOfficeList
            case .failure(_):
                isNetwork = false
            }
        }
    }
    
    @objc func searchBtnTapped() {
        if searchTextField.text != nil {
            networking(date: searchTextField.text ?? "")
        }
        view.endEditing(true)
    }
    
}

extension MovieSearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            networking(date: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            networking(date: textField.text ?? "")
            view.endEditing(true)
        }
        return false
    }
}

extension MovieSearchViewController
: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return isNetwork ? searchMovieList.count : 1
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if isNetwork {
            guard let cell = movieListTableView.dequeueReusableCell(
                withIdentifier: SearchMovieListTableViewCell.identifier,
                for: indexPath
            ) as? SearchMovieListTableViewCell else { return UITableViewCell() }
            let movie = searchMovieList[indexPath.row]
            cell.configureUI(with: movie)
            return cell
        } else {
            guard let cell = movieListTableView.dequeueReusableCell(
                withIdentifier: WrongDataTableViewCell.identifier,
                for: indexPath
            ) as? WrongDataTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
}
