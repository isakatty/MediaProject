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
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
        configureUI(movieInfo: movieInfo)
    }

    private func configureHierarchy() {
        [movieInfoView]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
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
}
