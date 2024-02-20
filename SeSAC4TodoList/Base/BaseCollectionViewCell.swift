//
//  BaseCollectionViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    
    func configureView() {
        contentView.backgroundColor = SeSACColor.slightDarkGray.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
