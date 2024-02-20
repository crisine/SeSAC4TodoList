//
//  BaseTableViewCell.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/21/24.
//

import UIKit
import SwiftUI
import SnapKit

class BaseTableViewCell: UITableViewCell, ReusableView {
    
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    
    func configureView() {
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
