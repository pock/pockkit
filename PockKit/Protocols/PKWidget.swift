//
//  PKWidget.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 19/05/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit

/// Pock widget protocol.
@objc (PKWidget) public protocol PKWidget: AnyObject {
    
    // MARK: Required
    
    /// Widget's unique identifier.
    var identifier: NSTouchBarItem.Identifier { get }
    
    /// Widget's customization label.
    ///
    /// This value is showed under your widget's view in Pock `Customisation` view.
    var customizationLabel: String { get set }
    
    /// Widget's main content view.
    ///
    /// Remember to set this property on widget initialisation.
    var view: NSView! { get set }
    
    /// Default widget initialiser.
    init()
    
    // MARK: Optional
    
    /// Notifies the widget that its view is about to be added to a view hierarchy.
    @objc optional func viewWillAppear()
    
    /// Notifies the widget that its view was added to a view hierarchy.
    @objc optional func viewDidAppear()
    
    /// Notifies the widget that its view is about to be removed from a view hierarchy.
    @objc optional func viewWillDisappear()
    
    /// Notifies the widget that its view was removed from a view hierarchy.
    @objc optional func viewDidDisappear()
    
}
