//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation
import Version

extension String {
    /// Attempts to return the current String as a "Version" - or nil if the Version cannot be made
    var asVersion: Version? {
        return Version(self)
    }
}
