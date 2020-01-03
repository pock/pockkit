//
//  PKView.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 17/02/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation

/// `PKView` is a tappable `NSView` subclass.
open class PKView: NSView {
    
    // MARK: Core
    private var initialPosition: NSPoint?
    private var didCallLongPressHandler: Bool = false
    
    // MARK: Overrideables
    
    /// Override this property to define custom long-press delay.
    open var longPressDelay: TimeInterval = 0.5
    
    /// Override this function to define an action for user's tap.
    open func didTapHandler() { /**/ }
    
    /// Override this function to define an action for user's long press.
    open func didLongPressHandler() { /**/ }
    
    /// Override this function to define an action for user's left swipe.
    open func didSwipeLeftHandler()  { /**/ }
    
    /// Override this function to define an action for user's right swipe.
    open func didSwipeRightHandler() { /**/ }
    
    // MARK: Private handlers
    
    @objc private func _didLongPress() {
        self.didCallLongPressHandler = true
        didLongPressHandler()
    }
    
    // MARK: Overrides
    
    /// The natural size for the receiving view, considering only properties of the view itself.
    open override var intrinsicContentSize: NSSize {
        var rect = super.intrinsicContentSize
        rect.height = 30
        return rect
    }
    
    /// Informs the receiver that new set of touches has been recognized.
    override public func touchesBegan(with event: NSEvent) {
        /// Touches began
        super.touchesBegan(with: event)
        /// Get touch
        guard let touch = event.allTouches().first else { return }
        /// Get touch location
        let location = touch.location(in: self.superview)
        /// Check if location is in self
        if self.frame.contains(location) {
            self.initialPosition = location
            self.didCallLongPressHandler = false
            self.perform(#selector(_didLongPress), with: nil, afterDelay: longPressDelay)
        }
    }
    
    /// Returns that a set of touches have been removed.
    override public func touchesEnded(with event: NSEvent) {
        /// Cancel long press handler, if needed
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(_didLongPress), object: nil)
        /// Touches ended
        super.touchesEnded(with: event)
        /// Get touch
        guard didCallLongPressHandler == false, let touch = event.allTouches().first else { return }
        /// Get touch location
        let location = touch.location(in: self.superview)
        /// Check if location is in self
        if self.frame.contains(location) {
            /// Check location
            if location.x < initialPosition?.x ?? location.x {
                didSwipeLeftHandler()
            }else if location.x > initialPosition?.x ?? location.x {
                didSwipeRightHandler()
            }else {
                didTapHandler()
            }
        }
    }
}
