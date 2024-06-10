//
//  TrendMovieDetailViewController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/10/24.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit

// MARK: ScrollView의 height 제약 모호함 -> 스크롤 안됨

public class TrendMovieDetailViewController: UIViewController {
    public var movieInfo: MovieInfo?
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
    private lazy var contentView: UIView = {
      let view = UIView()
      return view
    }()
    private let movieInfoView = TrendMovieDetailHeaderView()
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
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
      [movieInfoView, movieInfoTableView]
            .forEach { contentView.addSubview($0) }
      scrollView.addSubview(contentView)
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        movieInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.snp.width).multipliedBy( 0.55 / 1.0 )
        }
        movieInfoTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(movieInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "출연"
    }
    private func configureUI(movieInfo: MovieInfo?) {
        guard let movieInfo else { return }
        movieInfoView.configureUI(with: movieInfo)
        networking(with: movieInfo)
    }
    private func networking(
        with movieInfo: MovieInfo
    ) {
        let pathParams: String = String(movieInfo.id) + "/credits"
        let url = PrivateKey.tmdb_search_URL + pathParams
        let queryParams: Parameters = ["language": "ko-KR"]
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": PrivateKey.TMDB_key
        ]
        
        AF.request(
            url,
            parameters: queryParams,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: MovieCredit.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let value):
                print("Success")
                self.trendDetailData[0].descriptionText = movieInfo.overview
                self.trendDetailData[1].actorInfo = value.cast
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension TrendMovieDetailViewController
: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return trendDetailData.count
    }
    public func tableView(
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
    
    public func tableView(
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
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TrendMovieDetailSectionView.identifier
        ) as? TrendMovieDetailSectionView
        else { return UIView() }
        
        view.configureUI(with: trendDetailData[section].section.rawValue)
        
        return view
    }
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
