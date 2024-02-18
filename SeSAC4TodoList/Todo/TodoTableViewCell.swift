//
//  TodoTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit
import SnapKit

class TodoTableViewCell: UITableViewCell {
    
    let circleButton = UIButton()
    let priorityImageView = UIImageView()
    let titleLabel = UILabel()
    let flagImageView = UIImageView()
    
    let dateLabel = UILabel()
    
    
    // TODO: 나중에 디테일을 올리려고 한다면 존재하는 UI 요소 개수에 따라 make를 다시 해주는 것을 고려해 볼 것.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [circleButton ,priorityImageView, titleLabel, flagImageView, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        
        /*
        if 메모, 태그, 날짜 있나없나 먼저 조사 -> 다 없을때만 centerY로 조절
        
        if priority = 우선도 표시
         타이틀은 무조건 있지만 깃발유무에 따라 trailing 부분을 if로 조절
        if 깃발 = 깃발 표시
         */
        
        circleButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(24)
        }
        
        priorityImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            make.size.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(priorityImageView.snp.trailing).offset(4)
            make.trailing.equalTo(flagImageView.snp.leading).inset(4)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.size.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.greaterThanOrEqualTo(24)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .black
        
        priorityImageView.tintColor = .systemBlue
        priorityImageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17)
        
        flagImageView.tintColor = .systemYellow
        
        dateLabel.textColor = .darkGray
        dateLabel.font = .systemFont(ofSize: 14)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
