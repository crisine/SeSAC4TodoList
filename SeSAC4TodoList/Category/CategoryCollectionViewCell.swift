//
//  CategoryCollectionViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let iconImageBackView = UIView()
    let iconImageView = UIImageView()
    let countLabel = UILabel()
    let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = SeSACColor.veryDarkGray.color
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }

    
    private func configureHierarchy() {
        [titleLabel, iconImageBackView, iconImageView, countLabel, categoryLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        
        iconImageBackView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.size.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(iconImageBackView)
            make.size.equalTo(32)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageBackView.snp.bottom).offset(8)
            make.leading.equalTo(iconImageBackView.snp.leading)
            make.width.greaterThanOrEqualTo(120)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(iconImageBackView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    private func configureView() {
        iconImageBackView.clipsToBounds = true
        iconImageBackView.layer.cornerRadius = 20
    
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        categoryLabel.font = .boldSystemFont(ofSize: 16)
        categoryLabel.textColor = .gray
        
        countLabel.font = .boldSystemFont(ofSize: 36)
        countLabel.textColor = .white
        countLabel.textAlignment = .right
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
