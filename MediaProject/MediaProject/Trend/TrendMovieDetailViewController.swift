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
// MARK: TableView는 ScrollView를 상속받은 것. 그래서 ScrollView 안에 TableView를 넣는 것은 약간 어색함.
// Tableview의 재사용 mechanism에도 문제가 있을 수 있음.
// scroll이 되면서 cell 재사용.
// TableView header / section 으로 구성한다면 ?

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
    
    public override func viewDidLoad() {
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
    private func configureUI(movieInfo: MovieInfo?) {
        guard let movieInfo else { return }
        
        NetworkService.shared.callMovieDetail(with: movieInfo) { [weak self] credit, info in
            guard let self = self else { return }
            self.trendDetailData[0].descriptionText = info.overview
            self.trendDetailData[1].actorInfo = credit.cast
        }
    }
    @objc private func naviBackButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        switch trendDetailData[section].section {
        case .overView:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: TrendMovieDetailHeaderView.identifier
            ) as? TrendMovieDetailHeaderView,
                  let movieInfo
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
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
