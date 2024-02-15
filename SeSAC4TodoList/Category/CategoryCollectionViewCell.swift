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
        [titleLabel, iconImageView, countLabel, categoryLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.size.equalTo(40)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.equalTo(iconImageView.snp.leading)
            make.width.greaterThanOrEqualTo(120)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        // TODO: View Lifecycle를 조사하고, view의 크기가 결정되는 시점에 이것을 불러야 함.
        DispatchQueue.main.async {
            self.iconImageView.clipsToBounds = true
            self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
            self.iconImageView.contentMode = .scaleToFill
        }
        
        print(iconImageView.frame.height)
        
        iconImageView.tintColor = .white
        
        categoryLabel.font = .boldSystemFont(ofSize: 16)
        categoryLabel.textColor = .gray
        
        countLabel.font = .boldSystemFont(ofSize: 40)
        countLabel.textColor = .white
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
