//
//  PKWidgetPreference.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 11/01/2020.
//

import Foundation
import AppKit

/// Pock widget preference protocol.
@objc (PKWidgetPreferences) public protocol PKWidgetPreference where Self: NSViewController {
    
    /// Widget's preference pane nib name.
    static var nibName: NSNib.Name { get }
    
    /// Resets preferences to default values.
    func reset()
    
}
