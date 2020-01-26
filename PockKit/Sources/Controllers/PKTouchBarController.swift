//
//  TouchBarController.swift
//  Pock
//
//  Created by Pierluigi Galdi on 21/10/2018.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit

/// A controller that manages a Touch Bar, typically loaded from a nib file.
open class PKTouchBarController: NSObject, NSTouchBarDelegate {
    
    // MARK: Variables
    
    /// The main `NSTouchBar` that will be presented.
    @IBOutlet open weak var touchBar: NSTouchBar?
    
    /// The main navigation controller.
    ///
    /// You should use this navigation controller if you want to push new controllers on Touch Bar from your widget.
    public weak var mainNavigationController: PKTouchBarNavigationController? {
        return executeTouchBarHelperMethod("mainNavigationController") as? PKTouchBarNavigationController
    }
    
    /// The nearest ancestor in the controller hierarchy that is a navigation controller.
    public weak var navigationController: PKTouchBarNavigationController?
    
    /// A boolean value that determines whether the controller is visible or not.
    public var isVisible: Bool = false
    
    // MARK: Initialisers
    
    /// Default initialiser
    override required public init() {
        super.init()
    }
    
    /// Initializes a new controller, loaded from its associated `NSNib`.
    open class func load<T: PKTouchBarController>(_ type: T.Type = T.self) -> T {
        let controller = T()
        controller.reloadNib(type)
        return controller
    }
    
    /// Reload the `NSNib` associated to this controller.
    open func reloadNib<T: PKTouchBarController>(_ type: T.Type = T.self) {
        Bundle(for: type).loadNibNamed(NSNib.Name(String(describing: type)), owner: self, topLevelObjects: nil)
        touchBar?.delegate = self
        self.didLoad()
    }
    
    // MARK: Overrideables
    
    /// Notifies the controller that its Touch Bar was loaded.
    ///
    /// Override this function to define custom behaviours on load.
    open func didLoad() {
        /// override in subclasses.
    }
    
    // MARK: Private methods
    
    @discardableResult
    private func executeTouchBarHelperMethod(_ methodName: String, for touchBar: NSTouchBar? = nil) -> AnyObject? {
        guard let clss = objc_getClass("Pock.TouchBarHelper") as? NSObjectProtocol else {
            return nil
        }
        let selector = Selector(methodName)
        guard let touchBar = touchBar else {
            return clss.perform(selector)?.takeUnretainedValue()
        }
        return clss.perform(selector, with: touchBar)?.takeRetainedValue()
    }
    
    // MARK: Public methods
    
    /// Dismisses the currently displaying controller.
    open func dismiss() {
        executeTouchBarHelperMethod("dismissFromTop:", for: touchBar)
        self.isVisible = false
    }
    
    /// Minimize the currently displaying controller.
    open func minimize() {
        executeTouchBarHelperMethod("minimizeFromTop:", for: touchBar)
        self.isVisible = false
    }
    
    /// Presents this controller.
    open func present() {
        self.reloadNib()
        executeTouchBarHelperMethod("presentOnTop:", for: touchBar)
        self.isVisible = true
    }
    
    /// Push controller to main navigation controller.
    open func pushOnMainNavigationController() {
        self.mainNavigationController?.push(self)
    }
    
}
