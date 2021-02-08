//
//  PKTouchBarNavigationController.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 05/05/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation

/// A container controller that defines a stack-based scheme for navigating hierarchical content.
public class PKTouchBarNavigationController {
    
    // MARK: Core
    
    /// The controller that resides at the bottom of the navigation stack.
    public private(set) weak var rootController: PKTouchBarController?
    
    /// The controllers currently on the navigation stack.
    public private(set) var childControllers: [PKTouchBarController] = []
    
    /// The controller that resides at the top of the navigation stack.
    public var visibleController: PKTouchBarController? {
        return childControllers.last
    }
    
    // MARK: Initialiser
    
    /// Initializes a new navigation controller.
    ///
    /// - parameter rootController: The controller that resides at the bottom of the navigation stack.
    public init(rootController: PKTouchBarController) {
        self.rootController = rootController
        self.push(rootController)
    }
    
    // MARK: Public methods
    
    /// Pushes a controller onto the receiver’s stack and updates the display.
    ///
    /// - parameter controller: The controller to push onto the stack.
    public func push(_ controller: PKTouchBarController) {
		visibleController?.isVisible = false
        childControllers.append(controller)
        controller.navigationController = self
        controller.present()
    }
    
    /// Pops the top controller from the navigation stack and updates the display.
    public func popLastController() {
        var controller = childControllers.popLast()
        controller?.navigationController = nil
        if controller?.isVisible == true {
            controller?.dismiss()
        }
        controller = nil
		visibleController?.isVisible = true
    }
    
    /// Pops all the controllers on the stack except the root controller and updates the display.
    public func popToRootController() {
        let count = childControllers.count
        guard count > 1 else {
            return
        }
        for _ in 1..<count {
            self.popLastController()
        }
    }
    
    /// Dismisses the currently displaying navigation controller.
    public func dismiss() {
        popToRootController()
        popLastController()
        childControllers.removeAll()
        rootController = nil
    }
    
    /// Minimize the currently displaying navigation controller.
    public func minimize() {
		childControllers.reversed().forEach({ $0.minimize() })
    }
    
    /// De-minimize the currently displaying navigation controller.
    public func deminimize() {
        childControllers.forEach({ $0.present() })
    }
    
    /// Toggle the visibility of the currently displaying navigation controller.
    public func toggle() {
        if rootController?.isVisible ?? false {
            minimize()
        }else {
            deminimize()
        }
    }
    
}
