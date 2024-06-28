//
//  TrendMovieViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import SnapKit

final class TrendMovieViewController: BaseViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        network()
    }
    
    private func configureHierarchy() {
        view.addSubview(movieTableView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        movieTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        configureNavi(title: viewTitle)
    }
    
    private func network() {
        NetworkService.shared.callTMDB(
            endPoint: .trendingMovie,
            type: Trend.self
        ) { [weak self] trend, error in
            if let error {
                print("NetworkService - Trend 통신 Error", error)
            } else {
                guard let self else { return }
                guard let trend else { return }
                self.trendMovie = trend.results
            }
        }
    }
}

extension TrendMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return trendMovie.count
    }
    
    func tableView(
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
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.reloadData()
        
//        let vc = TrendMovieDetailViewController(movieInfo: trendMovie[indexPath.row])
        let vc = RecommendMoviesViewController(movie: trendMovie[indexPath.row])
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
