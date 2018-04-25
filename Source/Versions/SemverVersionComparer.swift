//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation
import Version


/// Concrete implementation of the VersionComparer that uses Semver versioning
class SemverVersionComparer: VersionComparer {
    typealias SupplierType = SemverVersionSupplier
}

extension VersionComparer where SupplierType.VersionType == Version {
    func compareIfLeftSideLessThan(leftSide: Version, rightSide: Version) -> Bool {
        return leftSide < rightSide
    }
}
