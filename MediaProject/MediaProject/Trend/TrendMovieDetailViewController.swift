//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

public class TrendMovieDetailViewController: UIViewController {
    public var movieInfo: MovieInfo?
    private let movieInfoView = TrendMovieDetailHeaderView()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .yellow
        scroll.autoresizingMask = .flexibleHeight
        return scroll
    }()
    private lazy var movieInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            TrendMovieDetailDescriptionTableViewCell.self,
            forCellReuseIdentifier: TrendMovieDetailDescriptionTableViewCell.identifier
        )
        tableView.register(
            TrendMovieDetailActorInfoTableViewCell.self,
            forCellReuseIdentifier: TrendMovieDetailActorInfoTableViewCell.identifier
        )
        tableView.register(
            TrendMovieDetailSectionView.self, 
            forHeaderFooterViewReuseIdentifier: TrendMovieDetailSectionView.identifier
        )
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        configureUI(movieInfo: movieInfo)
    }

    private func configureHierarchy() {
        [scrollView]
            .forEach { view.addSubview($0) }
        [movieInfoView]
            .forEach { scrollView.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        movieInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(safeArea.snp.width).multipliedBy( 0.55 / 1.0 )
        }
    }
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "출연"
    }
    private func configureUI(movieInfo: MovieInfo?) {
        guard let movieInfo else { return }
        movieInfoView.configureUI(with: movieInfo)
    }
    private func networking() {
        
    }
}

extension TrendMovieDetailViewController
: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        <#code#>
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        <#code#>
    }
}
