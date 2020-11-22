//
//  Task.swift
//  ToDoList
//
//  Created by Crypto on 11/19/20.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}
struct Task {
    let taskTitle: String
    let taskPriority: Priority
}
