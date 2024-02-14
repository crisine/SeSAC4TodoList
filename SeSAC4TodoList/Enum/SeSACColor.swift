//
//  SeSACColor.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/14/24.
//

import UIKit

enum SeSACColor {
    
    case slightDarkGray
    case veryDarkGray
    
    var color: UIColor {
        switch self {
        case .slightDarkGray:
            return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .veryDarkGray:
            return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        }
    }
}
