//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation

// MARK - Concrete Upgrade Tasks

/// On upgrading from 4.x to any version pose 5 - we need to clear any user sessions if the user is opted in
struct WL360Upgrade: UpgradeTask {
    func perform(completion: @escaping UpgradeTask.Completion) {
        if WL360OptIn.userOptedIn {
            LoginService.sharedInstance().clearLocalSession()
            CoreDataHelper.sharedInstance().clearAllWatchlists()
        }
        completion(.success)
    }
    
    var minimumVersionToPerform: SemverVersionSupplier {
        return SemverVersionSupplier(version: "5.0.0")
    }
}

// MARK: - Delete all watchlists support
extension CoreDataHelper {
    
    /// This will delete every MyStocksList on the device and save
    func clearAllWatchlists() {
        let context = CoreDataHelper.sharedInstance().contextForBackgroundThread()
        let watchlistFetch = NSFetchRequest<MyStocksList>(entityName: MyStocksList.entityName())
        do {
            let allLists = try context.fetch(watchlistFetch)
            allLists.forEach{
                context.delete($0)
            }
            try context.save()
        }
        catch {
            return
        }
    }
}
