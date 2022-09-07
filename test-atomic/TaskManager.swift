//
//  TaskManager.swift
//  test-atomic
//
//  Created by Cesare Rocchi on 07/09/22.
//

import UIKit

class TaskObject: NSObject {
    public var title: String
    init(title: String) {
        self.title = title
        super.init()
    }
    override var debugDescription: String {
        return title
    }
}

class TaskManager: NSObject {
    @Atomic private var loading: Bool = false
    @Atomic public private(set) var objects: [TaskObject] = []
    
    public func load() {
        if loading {
            print("already loading")
            return
        }
        loading = true
        var tmp: [TaskObject] = []
        for i in 1...5 {
            tmp.append(TaskObject(title: "task\(i)"))
        }
        objects = tmp
        print("loaded")
        loading = false
    }
}

@propertyWrapper
class Atomic<Value> {
    private let queue = DispatchQueue(label: "ai.memory.\(UUID().uuidString)")
    private var value: Value

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            queue.sync {
                value
            }
        }
        set {
            queue.sync (flags: .barrier) {
                self.value = newValue
                print("new value set \(newValue)")
            }
        }
    }
}
