//
//  TouchBarController.swift
//  Pock
//
//  Created by Pierluigi Galdi on 21/10/2018.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit

extension String {
	/// Memory-safe `String`'s initialiser to extract plain class name from given `AnyClass`.
	///
	/// The use of `NSStringFromClass` could lead to some memory-leak issue in certain situation.
	///
	/// What this custom initialiser does is executing `NSStringFromClass(_:)` inside an `autoreleasepool` to avoid any possible leakages.
	init(_ clss: AnyClass) {
		self.init()
		autoreleasepool(invoking: {
			let clssName = NSStringFromClass(clss)
			if let realClssName = clssName.split(separator: ".").last {
				self = String(realClssName)
			} else {
				self = clssName
			}
		})
	}
}

/// A controller that manages a Touch Bar.
open class PKTouchBarController: NSResponder, NSTouchBarDelegate {
    
    // MARK: Variables
    
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
	
	/// The `NSTouchBar` object associated with this controller.
	///
	/// If no `NSTouchBar` is explicitly set, `PKTouchBarController` will send `-makeTouchBar` to itself to create the default `NSTouchBar`,
	/// just like `NSResponser` does.
	@IBOutlet open override var touchBar: NSTouchBar? {
		get {
			return super.touchBar
		}
		set {
			super.touchBar = newValue
		}
	}
	
    // MARK: Initialisers
    
    /// Default initialiser
    override required public init() {
        super.init()
    }
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	/// Deinit
	deinit {
		invalidateTouchBar()
	}
    
    /// Initializes a new controller, loaded from its associated `NSNib`.
    open class func load<T: PKTouchBarController>(_ type: T.Type = T.self) -> T {
        let controller = T()
        controller.reloadNib(type)
        return controller
    }
    
    /// Reload the `NSNib` associated to this controller.
    open func reloadNib<T: PKTouchBarController>(_ type: T.Type = T.self) {
		let clssName = String(type)
        Bundle(for: type).loadNibNamed(NSNib.Name(clssName), owner: self, topLevelObjects: nil)
		didLoad()
    }
    
    // MARK: Overrideables
    
    /// Notifies the controller that its Touch Bar was loaded.
    ///
    /// Override this function to define custom behaviours on load.
    open func didLoad() {
        /// override in subclasses.
    }
	
	/// Invalidate current `touchBar` property.
	///
	/// Override this function to define custom behaviours on `touchBar`'s invalidation.
	///
	/// Remember to execute `touchBar = nil` or `super.invalidateTouchBar()` somewhere in your implementation.
	open func invalidateTouchBar() {
		touchBar = nil
	}
    
    // MARK: Private methods
    
    @discardableResult
    private func executeTouchBarHelperMethod(_ methodName: String, for touchBar: NSTouchBar? = nil) -> AnyObject? {
		let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Pock"
		let target = name.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "(", with: "_").replacingOccurrences(of: ")", with: "_")
        guard let clss = objc_getClass("\(target).TouchBarHelper") as? NSObjectProtocol else {
            return nil
        }
        let selector = Selector(methodName)
        guard let touchBar = touchBar else {
			if methodName == "hideCloseButtonIfNeeded" {
				clss.perform(selector)
				return nil
			}
			return clss.perform(selector)?.takeUnretainedValue()
        }
        clss.perform(selector, with: touchBar)
        return nil
    }
    
    // MARK: Public methods
    
    /// Dismisses the currently displaying controller.
    open func dismiss() {
		defer {
			invalidateTouchBar()
		}
		guard isVisible else {
			return
		}
        if let navController = self.navigationController {
            navController.popLastController()
        }else {
            isVisible = false
            executeTouchBarHelperMethod("dismissFromTop:", for: touchBar)
        }
    }
    
    /// Minimize the currently displaying controller.
    open func minimize() {
		defer {
			invalidateTouchBar()
		}
		guard isVisible else {
			return
		}
		isVisible = false
        executeTouchBarHelperMethod("minimizeFromTop:", for: touchBar)
    }
    
    /// Presents this controller.
    open func present() {
		guard !isVisible else {
			return
		}
        isVisible = true
        executeTouchBarHelperMethod("presentOnTop:", for: touchBar)
		executeTouchBarHelperMethod("hideCloseButtonIfNeeded")
    }
    
    /// Push controller to main navigation controller.
    open func pushOnMainNavigationController() {
        self.mainNavigationController?.push(self)
    }
    
}
