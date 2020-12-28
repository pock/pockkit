//
//  PKScreenEdgeController.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 15/11/20.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

@objc public class PKScreenEdgeController: NSWindowController {
	
	/// Core
	private var trackingArea: NSTrackingArea?
	
	/// Delegates
	public private(set) weak var mouseDelegate: PKScreenEdgeMouseDelegate?
	
	/// Data
	private var screenBottomEdgeRect: NSRect {
		return NSRect(x: window?.frame.origin.x ?? 0, y: 0, width: mouseDelegate?.visibleRectWidth ?? 0, height: 10)
	}
	
	/// Deinit
	deinit {
		NSLog("[PKScreenEdgeController]: Deinit for delegate: `\(object_getClass(mouseDelegate) ?? Self.self)`")
		mouseDelegate = nil
		tearDown()
	}
	
	/// Private initialiser
	internal convenience init(mouseDelegate: PKScreenEdgeMouseDelegate?) {
		/// Create tracking window
		let window: NSWindow? = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false, screen: NSScreen.main)
		window?.collectionBehavior   	  = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
		window?.isExcludedFromWindowsMenu = true
		window?.isReleasedWhenClosed 	  = true
		window?.ignoresMouseEvents   	  = false
		window?.hidesOnDeactivate    	  = false
		window?.canHide 		     	  = false
		window?.level 				 	  = .mainMenu
		window?.animationBehavior    	  = .none
		window?.hasShadow  				  = false
		window?.isOpaque   				  = false
		#if DEBUG
		window?.backgroundColor 		  = .random
		window?.alphaValue 				  = 1
		#else
		window?.backgroundColor 		  = .clear
		window?.alphaValue 				  = 1
		#endif
		/// Dragging support
		window?.registerForDraggedTypes([.URL, .fileURL, .filePromise])
		/// Create controller
		self.init(window: window)
		self.mouseDelegate = mouseDelegate
		/// Setup window
		window?.orderFrontRegardless()
		window?.delegate = self
		self.snapToScreenBottomEdge()
		/// Log
		NSLog("[ScreenEdgeController]: Setup for: \(object_getClass(mouseDelegate ?? self) ?? Self.self)...")
	}
	
	/// Tear down
	public func tearDown(invalidate: Bool = false) {
		if let trackingArea = trackingArea {
			window?.contentView?.removeTrackingArea(trackingArea)
		}
		window?.close()
		if invalidate {
			mouseDelegate = nil
		}
	}
	
	private func snapToScreenBottomEdge() {
		if let previousTrackingArea = trackingArea {
			window?.contentView?.removeTrackingArea(previousTrackingArea)
			trackingArea = nil
		}
		guard let window = window else {
			return
		}
		window.setFrame(screenBottomEdgeRect, display: true, animate: false)
		window.centerHorizontally()
		trackingArea = NSTrackingArea(rect: window.contentView?.bounds ?? screenBottomEdgeRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways], owner: self, userInfo: nil)
		window.contentView?.addTrackingArea(trackingArea!)
	}
	
}

// MARK: Mouse Delegate
extension PKScreenEdgeController: NSWindowDelegate {
	
	/// Mouse did enter in edge window
	override public func mouseEntered(with event: NSEvent) {
		guard let delegate = mouseDelegate, let point = window?.mouseLocationOutsideOfEventStream else {
			return
		}
		delegate.screenEdgeController(self, mouseEnteredAtLocation: point)
	}
	
	/// Did move mouse in edge window
	override public func mouseMoved(with event: NSEvent) {
		guard let delegate = mouseDelegate, let point = window?.mouseLocationOutsideOfEventStream else {
			return
		}
		delegate.screenEdgeController(self, mouseMovedAtLocation: point)
	}
	
	/// Did scroll mouse in edge window
	override public func scrollWheel(with event: NSEvent) {
		guard let delegate = mouseDelegate else {
			return
		}
		delegate.screenEdgeController?(self, mouseScrollWithDelta: event.deltaX, atLocation: event.locationInWindow)
	}
	
	/// Did click in edge window
	override public func mouseUp(with event: NSEvent) {
		guard let delegate = mouseDelegate else {
			return
		}
		delegate.screenEdgeController(self, mouseClickAtLocation: event.locationInWindow)
	}
	
	/// Mouse did exit from edge window
	override public func mouseExited(with event: NSEvent) {
		mouseDelegate?.screenEdgeController(self, mouseExitedAtLocation: event.locationInWindow)
	}

}

// MARK: Dragging Delegate
extension PKScreenEdgeController: NSDraggingDestination {
	
	public func wantsPeriodicDraggingUpdates() -> Bool {
		return false
	}
	
	public func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		guard let delegate = mouseDelegate,
			  let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
			  let path = pasteboard[0] as? String else {
			return NSDragOperation()
		}
		return delegate.screenEdgeController?(self, draggingEntered: sender, filepath: path) ?? NSDragOperation()
	}
	
	public func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
		guard let delegate = mouseDelegate,
			  let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
			  let path = pasteboard[0] as? String else {
			return NSDragOperation()
		}
		return delegate.screenEdgeController?(self, draggingUpdated: sender, filepath: path) ?? NSDragOperation()
	}
	
	public func draggingExited(_ sender: NSDraggingInfo?) {
		guard let delegate = mouseDelegate, let location = sender?.draggingLocation ?? window?.mouseLocationOutsideOfEventStream else {
			return
		}
		delegate.screenEdgeController(self, mouseExitedAtLocation: location)
	}
	
	public func draggingEnded(_ sender: NSDraggingInfo) {
		guard let delegate = mouseDelegate else {
			return
		}
		delegate.screenEdgeController?(self, draggingEnded: sender)
	}
	
	public func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		guard let delegate = mouseDelegate,
			  let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
			  let path = pasteboard[0] as? String else {
			return false
		}
		return delegate.screenEdgeController?(self, performDragOperation: sender, filepath: path) ?? false
	}
	
}

private extension NSColor {
	static var random: NSColor {
		return NSColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
	}
}

private extension NSWindow {
	func centerHorizontally() {
		if let screenSize = screen?.frame.size {
			self.setFrameOrigin(NSPoint(x: (screenSize.width - frame.size.width) / 2, y: frame.origin.y))
		}
	}
}
