//
//  PKScreenEdgeMouseDelegate.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 20/11/20.
//

@objc public protocol PKScreenEdgeMouseDelegate: class {
	
	// MARK: Required
	
	/// The size width for the edge window that reflects your widget visible rect
	var visibleRectWidth: CGFloat { get set }
	
	/// Mouse entered at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse entered inside edge-window
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseEnteredAtLocation location: NSPoint)
	
	/// Mouse did move at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse moved inside edge-window
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseMovedAtLocation location: NSPoint)
	
	/// Mouse clicked at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location where the mouse clicked inside edge-window
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseClickAtLocation location: NSPoint)
	
	/// Mouse exited at location
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter location: The location from where the mouse exited the edge-window
	func screenEdgeController(_ controller: PKScreenEdgeController, mouseExitedAtLocation location: NSPoint)
	
	// MARK: Optionals
	
	/// Mouse did scroll with delta at location
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter delta: The scroll delta. Use this information to relayout your elements
	/// - parameter location: The location where the mouse scrolled inside edge-window
	@objc optional func screenEdgeController(_ controller: PKScreenEdgeController, mouseScrollWithDelta delta: CGFloat, atLocation location: NSPoint)
	
	/// Dragging entered with info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	@objc optional func screenEdgeController(_ controller: PKScreenEdgeController, draggingEntered info: NSDraggingInfo, filepath: String) -> NSDragOperation
	
	/// Dragging updated with info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	@objc optional func screenEdgeController(_ controller: PKScreenEdgeController, draggingUpdated info: NSDraggingInfo, filepath: String) -> NSDragOperation
	
	/// Dragging perform operation info for file at path
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	/// - parameter filepath: The path of the dragged file
	@objc optional func screenEdgeController(_ controller: PKScreenEdgeController, performDragOperation info: NSDraggingInfo, filepath: String) -> Bool
	
	/// Dragging ended with info
	///
	/// This function is optional
	///
	/// - parameter controller: The controller that notified the delegate
	/// - parameter info: Object containing all information about dragging session
	@objc optional func screenEdgeController(_ controller: PKScreenEdgeController, draggingEnded info: NSDraggingInfo)
	
}
