//
//  BaseViewController.swift
//  SeSAC4Week9
//
//  Created by Minho on 2/14/24.
//

import UIKit
import SnapKit
import Toast

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        print("Base viewDidLoad")
    }

    func configureHierarchy() {
        
    }
    
    func configureConstraints() { 
        print(#function)
    }
    
    func configureView() {
        view.backgroundColor = .black // 배경 색상 white로 고정
        print(#function)
    }
    
    /**
        어떤 뷰 컨트롤러에서든 Alert 알림을 띄워주기 위해 사용할 수 있는 showAlert() 함수
     
        - parameters:
            - title: Alert 창의 제목
            - message: Alert 창에 표시될 내용
            - okTitle: Alert 창의 확인 버튼에 표시할 내용
            - handler: okAction(버튼) 이 눌렸을 때 할 작업을 적는 클로저
     */
    func showAlert(title: String, message: String, okTitle: String,
                   handler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            handler()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    /**
        어떤 뷰 컨트롤러에서든 토스트 메시지를 작성하기 위해서 사용할 수 있는 showToast() 함수
     
        - parameters:
            - message: 토스트 메시지로 띄울 문자열
     */
    func showToast(message: String) {
        view.makeToast(message)
    }
    
    
}
