//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation


/// UpgradeTask is a piece of work that is ran when certain conditions are met relating to an application's version changing
protocol UpgradeTask {
    typealias Completion = (UpgradeTaskCompletionState)->Void
    /// The minimum version the app should be at to perform the task. This should be a valid semver 2.0.0 string
    var minimumVersionToPerform: SemverVersionSupplier { get }
    
    var versionComparer: SemverVersionComparer { get }
    
    /// If the last launchedVersion is < the minimumVersionToPerform - the TaskRunner will run this task
    ///
    /// - Parameter lastLaunchedVersion: The last launched verison, this must be a semver stringbe
    /// - Returns: Yes if the lastLaunchedVersion is < minimumVersionToPerform
    func shouldPerform(_ lastLaunchedVersion: SemverVersionSupplier) -> Bool
    
    
    /// Perform's the task
    func perform(completion: @escaping Completion)
}


/// A completion state used to determine success or failure of a task
///
/// - success: The task was a success
/// - error: Some error occurred
enum UpgradeTaskCompletionState {
    case success
    case error(Error)
}


// MARK: - Base implementation
extension UpgradeTask {
    var versionComparer: SemverVersionComparer {
        return SemverVersionComparer()
    }
    
    func shouldPerform(_ lastLaunchedVersion: SemverVersionSupplier) -> Bool {
        return minimumVersionToPerform.version > lastLaunchedVersion.version
    }
}
