//
//  TodoCategoryRepositoryProtocol.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/22/24.
//

import Foundation
import RealmSwift

protocol TodoCategoryRepositoryProtocol {
    
    func add(item: TodoCategory)
    
    func fetch() -> Results<TodoCategory>
    func fetchFilter(_ filter: NSPredicate) -> Results<TodoCategory>
    
    func update(item: TodoCategory)
    
    func delete(item: TodoCategory)
    
}
