//  Copyright © 2018 IHS Markit Inc. All rights reserved.
//

import Foundation

// MARK - Version Comparer

/// The VersionComparer helps abstract details on what a version is
protocol VersionComparer {
    associatedtype SupplierType: VersionSupplier
    
    /// Compares the left side to see if it is less than the right side
    ///
    /// - Parameters:
    ///   - leftSide: The left side VersionType to compare
    ///   - rightSide: The right side VersionType to compare
    /// - Returns: True if the left side is less than the right side
    func compareIfLeftSideLessThan(leftSide: SupplierType.VersionType, rightSide: SupplierType.VersionType) -> Bool
}


// MARK - Version Supplier

/// Abstracts how a version is supplied for comparison purposes
protocol VersionSupplier {
    associatedtype VersionType: Comparable
    
    /// Returns a version of "VersionType"
    var version: VersionType { get }
}
