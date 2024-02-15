//
//  TodoTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/15/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        [titleLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(4)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.greaterThanOrEqualTo(24)
        }
    }
    
    private func configureView() {
        contentView.backgroundColor = .black
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17)
        
        dateLabel.textColor = .darkGray
        dateLabel.font = .systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
