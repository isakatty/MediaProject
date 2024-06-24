//
//  TrendMovieViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Alamofire
import SnapKit

public class TrendMovieViewController: UIViewController {
    
    private var trendMovie = [MovieInfo]() {
        didSet {
            movieTableView.reloadData()
        }
    }
    private lazy var movieTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(
            TrendTableViewCell.self,
            forCellReuseIdentifier: TrendTableViewCell.identifier
        )
        table.separatorStyle = .none
        table.rowHeight = 320
        return table
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        networkTrend()
    }
    
    private func configureHierarchy() {
        view.addSubview(movieTableView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        movieTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "트렌드"
    }

    private func networkTrend() {
        let url = PrivateKey.tmdb_URL
        let params: Parameters = ["language": "ko-KR"]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": PrivateKey.TMDB_key
        ]
        
        AF.request(
            url,
            parameters: params,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Trend.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let value):
                self.trendMovie = value.results
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension TrendMovieViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return trendMovie.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrendTableViewCell.identifier,
            for: indexPath
        ) as? TrendTableViewCell else { return UITableViewCell() }
        
        cell.configureUI(movieInfo: trendMovie[indexPath.row])
        
        return cell
    }
    
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.reloadData()
        
        let vc = TrendMovieDetailViewController()
        vc.movieInfo = trendMovie[indexPath.row]
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    public func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
