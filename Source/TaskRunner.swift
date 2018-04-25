//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation

/// This class is designed to perform a series of tasks against app version criteria
class TaskRunner {
    public static let shared: TaskRunner = TaskRunner.runnerWithDefaultTasks
    
    private let previousVersionSupplier = PreviousVersionSupplier()
    private let initialTasks: [UpgradeTask]
    private var taskQueue = [UpgradeTask]()
    
    init(tasks: [UpgradeTask]) {
        self.initialTasks = tasks.reversed()
    }
    
    static var runnerWithDefaultTasks: TaskRunner {
        return TaskRunner(tasks: [WL360Upgrade()])
    }
    
    var isRunning: Bool {
        return taskQueue.isEmpty == false
    }
    
    
    func performAll() {
        guard isRunning == false else {
            return
        }
        taskQueue = self.initialTasks.reversed()
        self.performNext()
    }
    
    private func performNext() {
        guard let nextTask = popNextTask() else {
            return
        }
        guard nextTask.shouldPerform(self.previousVersionSupplier) else {
            self.performNext()
            return
        }
        // TODO: completion states will be used for retry behavior / error handling if needed
        nextTask.perform(completion: { (state) in
            switch state {
            case .success:
                break
            case .error(let error):
                print(error)
            }
            self.performNext()
        })
    }
    
    
    /// Gets the next task from the active queue and returns it, removing it in the process
    ///
    /// - Returns: The next UpgradeTask or nil if no tasks are left
    private func popNextTask() -> UpgradeTask? {
        return taskQueue.popLast()
    }
}
