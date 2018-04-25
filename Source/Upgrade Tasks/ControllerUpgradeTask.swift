//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation


/// Adopt this on something that can generate a view controller for presentation with a ControllerUpgradeTask - or adopt on the view controller itself to return itself as the controller
protocol ControllerGeneratable {
    
    /// This value is set when the call this to complete a task - i.e. user interaction completed
    var completionContext: UpgradeTask.Completion? { get set }
    /// this is called when it is time to show the controller
    var generateController: UIViewController { get }
}


/// Allow a view controller to work as an UpgradeTask
class ControllerUpgradeTask: UpgradeTask {
    private(set) var controller: ControllerGeneratable
    let presentFrom: UIViewController
    
    init(toPresent: ControllerGeneratable, presentFrom: UIViewController) {
        self.controller = toPresent
        self.presentFrom = presentFrom
    }
    var minimumVersionToPerform: SemverVersionSupplier {
        return SemverVersionSupplier(version: "5.0.0")
    }
    
    func perform(completion: @escaping (UpgradeTaskCompletionState) -> Void) {
        // pass context
        controller.completionContext = completion
        self.presentFrom.present(controller.generateController, animated: true, completion: nil)
    }
}
