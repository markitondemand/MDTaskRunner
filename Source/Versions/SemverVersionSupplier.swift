//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation
import Version
import GBVersionTracking

/// Concrete implementation of VersionSupplier that uses Semver
class SemverVersionSupplier: VersionSupplier {
    typealias VersionType = Version
    var version: Version
    
    init(version: Version) {
        self.version = version
    }
    
    convenience init(version: String) {
        self.init(version: Version(version))
    }
}

// MARK - Concrete Version Suppliers

/// Returns a supplier that gets the current version in the main application bundle
class BundleVersionSupplier: SemverVersionSupplier {
    convenience init () {
        let zeroVersion = Version(stringLiteral: "0")
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            self.init(version: "0.0".asVersion ?? zeroVersion)
            return
        }
        self.init(version: bundleVersion.asVersion ?? zeroVersion)
    }
}

/// Returns a supplier that gets the previously launched version from the GBVersionTracking framework
class PreviousVersionSupplier: SemverVersionSupplier {
    convenience init() {
        let zeroVersion = Version(stringLiteral: "0")
        guard GBVersionTracking.isFirstLaunchForVersion() else {
            self.init(version: GBVersionTracking.currentVersion()?.asVersion ?? zeroVersion)
            return
        }
        self.init(version: GBVersionTracking.previousVersion()?.asVersion ?? zeroVersion)
    }
}
