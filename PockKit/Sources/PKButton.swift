//
//  PKButton.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 05/01/2020.
//

import Foundation

fileprivate class PKButtonCell: NSButtonCell {
    
    /// Default initialiser (title)
    override init(textCell string: String) {
        super.init(textCell: string)
        self.font = NSFont.systemFont(ofSize: 15)
    }
    
    /// Default initialiser (coder)
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var rect = super.titleRect(forBounds: rect)
        rect.origin.y -= 1
        return rect
    }
    
}

/// Pre-configured `NSButton` subclass that fit Touch Bar needs.
///
/// Pock `Esc` widget uses an instance of this type.
public class PKButton: NSButton {
    
    // MARK: Styles
    
    /// Button styles
    public enum Style {
        /// Default style.
        /// The ones used for `Esc` widget.
        case rounded
        /// Internal var to map `Style` to `BezerStyle`
        internal var bezelStyle: BezelStyle {
            switch self {
            case .rounded:
                return .rounded
            }
        }
    }
    
    // MARK: Variables
    
    /// `CGFloat` value that determines the maximum width the button must occupy.
    ///
    /// Set `0` for no limits.
    public private(set) var maxWidth: CGFloat = 0
    
    // MARK: Initialisers
    
    /// Create a new instance of type `PKButton`
    ///
    /// - parameter title: The title to be displayed on the button.
    /// - parameter maxWidth: Value that determines the maximum width the button can occupy.
    /// - parameter style: The style of the button. Can only be `rounded` for now. More styles will come.
    /// - parameter target: Tha action target.
    /// - parameter action: The action (`Selector`) to executed on button tap.
    public init(title: String, maxWidth: CGFloat = 0, style: Style = .rounded, target: Any? = nil, action: Selector? = nil) {
        super.init(frame: .init(x: 0, y: 0, width: maxWidth, height: 30))
        self.maxWidth   = maxWidth
        self.cell       = PKButtonCell(textCell: title)
        self.bezelStyle = style.bezelStyle

        let clickGesture = NSClickGestureRecognizer(target: target, action: action)
        clickGesture.allowedTouchTypes = .direct
        addGestureRecognizer(clickGesture)
    }
    
    /// Default initialiser (coder)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Overrides
    
    /// The natural size for the receiving view, considering only properties of the view itself.
    override public var intrinsicContentSize: NSSize {
        let size = super.intrinsicContentSize
        let width = maxWidth > 0 ? min(size.width, maxWidth) : size.width
        return .init(width: width, height: 30)
    }
    
}
