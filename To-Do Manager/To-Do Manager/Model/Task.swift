//
//  Task.swift
//  To-Do Manager
//
//  Created by Max Kuznetsov on 05.04.2022.
//

import Foundation

enum TaskPriority{
    case normal
    case important
}

enum TaskStatus: Int{
    case planned
    case completed
}

protocol TaskProtocol{
    var title: String {get set}
    var type: TaskPriority {get set}
    var status: TaskStatus {get set}
}

struct Task: TaskProtocol{
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
