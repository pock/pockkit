//
//  PKTouchBarMouseController.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 20/11/20.
//

/// A controller that manages a Touch Bar, typically loaded from a nib file, and can handle mouse and dragging events.
open class PKTouchBarMouseController: PKTouchBarController, PKScreenEdgeMouseDelegate {
	
	/// Current `ScreenEdgeController` instance.
	///
	/// Can be re-created at runtime, if needed.
	public var edgeController: PKScreenEdgeController?
	
	/// The total content size width for the edge window
	open var totalContentSizeWidth: CGFloat {
		return 0
	}
	
	public override var isVisible: Bool {
		didSet {
			edgeController?.window?.setIsVisible(isVisible)
		}
	}
	
	/// The parent view in which Cursor/Dragging Info will be added
	open var parentView: NSView!
	
	/// Cursor view
	public var cursorView: NSView?
	
	/// Dragging info view
	public var draggingInfoView: PKDraggingInfoView?
	
	
	open override func didLoad() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
			self?.reloadScreenEdgeController()
		})
	}
	
	open override func present() {
		super.present()
		guard !isVisible else {
			return
		}
		didLoad()
	}
	
	open override func dismiss() {
        showCursor(nil, at: nil)
        showDraggingInfo(nil, filepath: nil)
        edgeController?.tearDown(invalidate: true)
        edgeController = nil
        super.dismiss()
	}
	
	/// Re-create `edgeController` object
	@objc open func reloadScreenEdgeController() {
		self.edgeController = PKScreenEdgeController(mouseDelegate: self, parentView: parentView)
	}
	
	/// The size width for the edge window that reflects your widget visible rect
	open var visibleRectWidth: CGFloat {
		get {
			return parentView.visibleRect.width
		}
		set {
			fatalError("[PKTouchBarMouseController] You must override this property in subclass to use custom setter.")
		}
	}
	
	/// Mouse entered at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse entered inside edge-window
	open func screenEdgeController(_ controller: PKScreenEdgeController, mouseEnteredAtLocation location: NSPoint, in view: NSView) {
		showCursor(.arrow, at: location)
	}
	
	/// Mouse did move at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse moved inside edge-window
	open func screenEdgeController(_ controller: PKScreenEdgeController, mouseMovedAtLocation location: NSPoint, in view: NSView) {
		updateCursorLocation(location)
	}
	
	/// Mouse did scroll with delta at location
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter delta: The scroll delta. Use this information to relayout your elements
	/// - parameter location: The location where the mouse scrolled inside edge-window
	open func screenEdgeController(_ controller: PKScreenEdgeController, mouseScrollWithDelta delta: CGFloat, atLocation location: NSPoint, in view: NSView) {
		/// nothing to do here
	}
	
	/// Mouse clicked at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse clicked inside edge-window
	open func screenEdgeController(_ controller: PKScreenEdgeController, mouseClickAtLocation location: NSPoint, in view: NSView) {
		/// nothing to do here
	}
	
	/// Mouse exited at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location from where the mouse exited the edge-window
	open func screenEdgeController(_ controller: PKScreenEdgeController, mouseExitedAtLocation location: NSPoint, in view: NSView) {
		showCursor(nil, at: nil)
		showDraggingInfo(nil, filepath: nil)
	}
	
	/// Dragging entered with info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	open func screenEdgeController(_ controller: PKScreenEdgeController, draggingEntered info: NSDraggingInfo, filepath: String, in view: NSView) -> NSDragOperation {
		/// nothing to do here
		showDraggingInfo(info, filepath: filepath)
		return NSDragOperation()
	}
	
	/// Dragging updated with info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	open func screenEdgeController(_ controller: PKScreenEdgeController, draggingUpdated info: NSDraggingInfo, filepath: String, in view: NSView) -> NSDragOperation {
		/// nothing to do here
		updateDraggingInfoLocation(info.draggingLocation)
		return NSDragOperation()
	}
	
	/// Dragging perform operation info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	open func screenEdgeController(_ controller: PKScreenEdgeController, performDragOperation info: NSDraggingInfo, filepath: String, in view: NSView) -> Bool {
		/// nothing to do here
		return false
	}
	
	/// Dragging ended with info
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	open func screenEdgeController(_ controller: PKScreenEdgeController, draggingEnded info: NSDraggingInfo, in view: NSView) {
		/// nothing to do here
		showDraggingInfo(nil, filepath: nil)
	}
	
	/// Show cursor view with given cursor type at given location
	///
	/// - parameter cursor: The `NSCursor` type to be displayed
	/// - parameter location: The location where the cursor view will be placed
	open func showCursor(_ cursor: NSCursor?, at location: NSPoint?) {
		cursorView?.removeFromSuperview()
		cursorView = nil
		guard let cursor = cursor, let location = location else {
			updateCursorLocation(nil)
			return
		}
		cursorView = NSImageView(image: cursor.image)
		cursorView?.frame.size = NSSize(width: 20, height: 20)
		cursorView?.wantsLayer = true
		parentView?.addSubview(cursorView!)
		cursorView?.layer?.zPosition = 999
		updateCursorLocation(location)
	}
	
	/// Update cursor location on Touch Bar with given location
	///
	/// - parameter location: The location where the cursor view will be placed
	open func updateCursorLocation(_ location: NSPoint?) {
		guard let location = location else {
			return
		}
		cursorView?.frame.origin = location
	}
	
	/// Show dragging info view with given info for file at given path
	///
	/// - parameter info: The `NSDraggingInfo` object returned from `NSDestinationDelegate`
	/// - parameter filepath. The path of the dragged file
	open func showDraggingInfo(_ info: NSDraggingInfo?, filepath: String?) {
		draggingInfoView?.removeFromSuperview()
		draggingInfoView = nil
		guard let info = info, let filepath = filepath else {
			return
		}
		draggingInfoView = PKDraggingInfoView(filepath: URL(fileURLWithPath: filepath))
		draggingInfoView?.wantsLayer = true
		parentView?.addSubview(draggingInfoView!, positioned: .below, relativeTo: cursorView)
		draggingInfoView?.layer?.zPosition = 998
		updateDraggingInfoLocation(info.draggingLocation, animated: false)
	}
	
	/// Update dragging info view with given location.
	///
	/// - parameter location: The location where the dragging view will be placed
	/// - parameter animated: If `true`, dragging view will update its location after a delay, giving a nice slide-effect
	open func updateDraggingInfoLocation(_ location: NSPoint, animated: Bool = true) {
		guard let view = draggingInfoView else {
			return
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.1275 : 0), execute: {
			view.frame.origin = NSPoint(x: location.x - view.frame.width + 8, y: location.y)
		})
	}
	
}
