//
//  SearchMovieListTableViewCell.swift
//  MediaProject
//
//  Created by Jisoo HAM on 6/6/24.
//

import UIKit

import SnapKit

class SearchMovieListTableViewCell: UITableViewCell {

    let numberLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.font = .boldSystemFont(ofSize: 15)
        lb.textAlignment = .center
        return lb
    }()
    let movieTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .systemFont(ofSize: 13)
        return lb
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        backgroundColor = .clear
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureHierarchy() {
        [numberLabel, movieTitleLabel, dateLabel]
            .forEach { addSubview($0) }
    }
    func configureLayout() {
        numberLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(30)
            make.leading.equalToSuperview().offset(15)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(numberLabel.snp.trailing).offset(20)
            make.width.greaterThanOrEqualTo(80)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(80)
            make.leading.equalTo(movieTitleLabel.snp.trailing)
        }
    }
    /// 외부 호출, label에 데이터 넣어줄 함수
    func configureUI(with movie: DailyBoxOfficeList) {
        numberLabel.text = movie.rank
        movieTitleLabel.text = movie.movieNm
        dateLabel.text = movie.openDt
    }
    
}
