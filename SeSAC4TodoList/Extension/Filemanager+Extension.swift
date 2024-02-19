//
//  Filemanager+Extension.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/20/24.
//


import Foundation
import UIKit

extension UIViewController {
    
    func setFileURL(filename: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let imagesDirectory = documentDirectory.appending(path: "images")
        
        if !FileManager.default.fileExists(atPath: imagesDirectory.path()) {
            do {
                try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
            } catch {
                print("an error occured while creating images directory", error)
                return nil
            }
        }
        
        let fileURL = imagesDirectory.appendingPathComponent("\(filename).jpg")
        
        return fileURL
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        // 앱의 Document 위치
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error occured!!", error)
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이 경로에 실제로 파일이 존재하는지 확인
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
    }
}
