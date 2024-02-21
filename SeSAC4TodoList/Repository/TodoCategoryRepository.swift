//
//  TodoCategoryRepository.swift
//  SeSAC4TodoList
//
//  Created by Minho on 2/22/24.
//

import Foundation
import RealmSwift

// TODO: Repository를 <T> 제네릭으로 통합할 수 없을까?
class TodoCategoryRepository: TodoCategoryRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func add(item: TodoCategory) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("an error occured while adding items to Realm databse: \(error)")
        }
    }
    
    func fetch() -> RealmSwift.Results<TodoCategory> {
        return realm.objects(TodoCategory.self)
    }
    
    func fetchFilter(_ predicate: NSPredicate) -> RealmSwift.Results<TodoCategory> {
        return realm.objects(TodoCategory.self).filter(predicate)
    }
    
    func update(item: TodoCategory) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print("an error occured while updating items to Realm databse: \(error)")
        }
    }
    
    func delete(item: TodoCategory) {
        realm.delete(item)
    }
    
}
