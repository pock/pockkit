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
    @IBOutlet open var touchBar: NSTouchBar?
    
    /// The nearest ancestor in the view controller hierarchy that is a navigation controller.
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
        if touchBar == nil {
            touchBar = NSTouchBar()
            touchBar?.delegate = self
        }
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
    
    private func executeNSTouchBarMethod(_ methodName: String, for touchBar: NSTouchBar?) {
        guard let clss = objc_getClass("Pock.TouchBarHelper") as? NSObjectProtocol else {
            return
        }
        let selector = Selector(methodName)
        clss.perform(selector, with: touchBar)
    }
    
    // MARK: Public methods
    
    /// Dismisses the currently displaying controller.
    open func dismiss() {
        executeNSTouchBarMethod("dismissFromTop:", for: touchBar)
        self.isVisible = false
    }
    
    /// Minimize the currently displaying controller.
    open func minimize() {
        executeNSTouchBarMethod("minimizeFromTop:", for: touchBar)
        self.isVisible = false
    }
    
    /// Presents this controller.
    open func present() {
        self.reloadNib()
        executeNSTouchBarMethod("presentOnTop:", for: touchBar)
        self.isVisible = true
    }
    
}
