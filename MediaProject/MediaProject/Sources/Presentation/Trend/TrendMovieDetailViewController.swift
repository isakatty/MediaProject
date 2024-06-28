//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TrendMovieDetailViewController: UIViewController {
    var movieInfo: MovieInfo
    private var trendDetailData: [TrendDetail] = [
        TrendDetail(
            section: .overView,
            descriptionText: nil,
            actorInfo: nil
        ),
        TrendDetail(
            section: .cast,
            descriptionText: nil,
            actorInfo: nil
        )
    ] {
        didSet {
            movieInfoTableView.reloadData()
        }
    }
    
    init(movieInfo: MovieInfo) {
        self.movieInfo = movieInfo
        
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var movieInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        tableView.register(
            TrendMovieDetailHeaderView.self,
            forHeaderFooterViewReuseIdentifier: TrendMovieDetailHeaderView.identifier
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        configureUI(movieInfo: movieInfo)
    }

    private func configureHierarchy() {
      [movieInfoTableView]
        .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        movieInfoTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
        }
    }
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "출연"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(naviBackButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    private func configureUI(movieInfo: MovieInfo) {
        NetworkService.shared.callTMDB(
            endPoint: .trendDetail(movieId: String(movieInfo.id)),
            type: MovieCredit.self
        ) { [weak self] details, error in
            if let error {
                print("NetworkService - Movie Detail 통신 에러", error)
            } else {
                guard let self else { return }
                guard let details else { return }
                self.trendDetailData[0].descriptionText = movieInfo.overview
                self.trendDetailData[1].actorInfo = details.cast
            }
        }
    }
    @objc private func naviBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension TrendMovieDetailViewController
: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return trendDetailData.count
    }
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch trendDetailData[section].section {
        case .overView:
            return 1
        case .cast:
            return trendDetailData[section].actorInfo?.count ?? 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        switch trendDetailData[indexPath.section].section {
        case .overView:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrendMovieDetailDescriptionTableViewCell.identifier,
                for: indexPath
            ) as? TrendMovieDetailDescriptionTableViewCell,
                  let text = trendDetailData[indexPath.section].descriptionText
            else { return UITableViewCell() }
            
            cell.configureUI(descriptionText: text)
            
            return cell
        case .cast:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TrendMovieDetailActorInfoTableViewCell.identifier,
                for: indexPath
            ) as? TrendMovieDetailActorInfoTableViewCell
            else { return UITableViewCell() }
            
            cell.configureUI(cast: trendDetailData[indexPath.section].actorInfo?[indexPath.row])
            
            return cell
            
        }
    }
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        switch trendDetailData[section].section {
        case .overView:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TrendMovieDetailHeaderView.identifier
            ) as? TrendMovieDetailHeaderView
            else { return UIView() }
            
            headerView.configureUI(
                with: movieInfo,
                with: trendDetailData[section].section.rawValue
            )
            return headerView
            
        case .cast:
            guard let sectionView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TrendMovieDetailSectionView.identifier
            ) as? TrendMovieDetailSectionView
            else { return UIView() }
            
            sectionView.configureUI(with: trendDetailData[section].section.rawValue)
            
            return sectionView
        }
    }
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
