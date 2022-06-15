//
//  TaskStorage.swift
//  To-Do Manager
//
//  Created by Max Kuznetsov on 05.04.2022.
//

import Foundation

protocol TaskStorageProtocol{
    func loadTasks()->[TaskProtocol]
    func saveTasks(_ task: [TaskProtocol])
}

class TaskStorage: TaskStorageProtocol{
    
    private var storage = UserDefaults.standard
    var storageKey = "tasks"
    
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func loadTasks() -> [TaskProtocol] {
        var resultTasks: [TaskProtocol] = []
        let tasksFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue], let typeRaw = task[TaskKey.type.rawValue], let statusRaw = task[TaskKey.status.rawValue] else {
                continue
            }
            let type: TaskPriority = typeRaw == "important" ? .important : .normal
            let status: TaskStatus = statusRaw == "planned" ? .planned : .completed
            resultTasks.append(Task(title: title, type: type, status: status))
        }
        return resultTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = (task.type == .important ? "important" : "normal")
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned ? "planned" : "completed")
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
