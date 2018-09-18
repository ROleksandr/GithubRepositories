//
//  AsyncOperation.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/14/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

enum State: String {
    case ready, executing, finished
    fileprivate var keyPath: String {
        return "is" + rawValue.capitalized
    }
}

class AsyncOperation: Operation {
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    override var isAsynchronous: Bool {
        return true
    }
    override func cancel() {
        state = .finished
    }
}
