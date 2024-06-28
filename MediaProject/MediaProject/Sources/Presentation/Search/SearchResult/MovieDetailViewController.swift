//
//  MovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Kingfisher
import SnapKit

final class MovieDetailViewController: BaseViewController {
    var movieInfo: SearchedMovieInfo
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
    
    init(movieInfo: SearchedMovieInfo) {
        self.movieInfo = movieInfo
        
        super.init(viewTitle: ViewCase.movieDetail(movie: movieInfo.title).viewTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var movieInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(
            MovieDetailDescriptionTableViewCell.self,
            forCellReuseIdentifier: MovieDetailDescriptionTableViewCell.identifier
        )
        tableView.register(
            MovieDetailActorInfoTableViewCell.self,
            forCellReuseIdentifier: MovieDetailActorInfoTableViewCell.identifier
        )
        tableView.register(
            MovieDetailSectionView.self, 
            forHeaderFooterViewReuseIdentifier: MovieDetailSectionView.identifier
        )
        tableView.register(
            TrendMovieDetailHeaderView.self,
            forHeaderFooterViewReuseIdentifier: TrendMovieDetailHeaderView.identifier
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureUI(movieInfo: movieInfo)
    }

    private func configureHierarchy() {
      [movieInfoTableView]
        .forEach { view.addSubview($0) }
    }
    internal override func configureLayout() {
        super.configureLayout()
        let safeArea = view.safeAreaLayoutGuide
        
        movieInfoTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
        }
    }
    private func configureUI(movieInfo: SearchedMovieInfo) {
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
}

extension MovieDetailViewController
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
                withIdentifier: MovieDetailDescriptionTableViewCell.identifier,
                for: indexPath
            ) as? MovieDetailDescriptionTableViewCell,
                  let text = trendDetailData[indexPath.section].descriptionText
            else { return UITableViewCell() }
            
            cell.configureUI(descriptionText: text)
            
            return cell
        case .cast:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieDetailActorInfoTableViewCell.identifier,
                for: indexPath
            ) as? MovieDetailActorInfoTableViewCell
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
            else { return UITableViewHeaderFooterView() }
            
            headerView.configureUI(
                with: movieInfo,
                with: trendDetailData[section].section.rawValue
            )
            return headerView
            
        case .cast:
            guard let sectionView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: MovieDetailSectionView.identifier
            ) as? MovieDetailSectionView
            else { return UITableViewHeaderFooterView() }
            
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
