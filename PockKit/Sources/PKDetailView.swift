//
//  PKDetailView.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 26/05/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import SnapKit

open class PKDetailView: PKView {
    
    // MARK: Core
    private static let kBounceAnimationKey: String  = "kBounceAnimationKey"
    
    /// A boolean value that determines whether the `imageView` is animating or not.
    public private(set) var isAnimating: Bool = false
    
    /// `CGFloat` value that determines the maximum width the view can occupy.
    ///
    /// Set `0` for no limits.
    public var maxWidth: CGFloat = 0 {
        didSet {
            updateConstraint()
        }
    }
    
    /// A boolean value that determines whether the subviews layout should be `left to right` or `right to left`.
    ///
    /// Default is `true`
    public var leftToRight: Bool = true {
        didSet {
            updateConstraint()
        }
    }
    
    // MARK: UI Elements
    
    /// Icon image view.
    public var imageView:    NSImageView!
    
    /// Main scrolling text view.
    public var titleView:    ScrollingTextView!
    
    /// Secondary scrolling text view.
    public var subtitleView: ScrollingTextView!
    
    // MARK: Variables
    
    /// A boolean value that determines whether the `title` text view should scroll or not.
    ///
    /// Default is `false`
    public var canScrollTitle: Bool = false
    
    /// A boolean value that determines whether the `subtitle` text view should scroll or not.
    ///
    /// Default is `false`
    public var canScrollSubtitle: Bool = false
    
    /// A boolean value that determines whether the icon image view should be hidden or not.
    ///
    /// Default is `false`
    public var shouldHideIcon: Bool = false {
        didSet {
            updateConstraint()
        }
    }
    
    // MARK: Initialisers
    
    /// Default initialiser.
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.leftToRight = true
        self.load()
    }
    
    /// Initialise an istance of `PKDetailView` with given information.
    ///
    /// - parameter frame: The given `NSRect` to use for view's frame.
    /// - parameter leftToRight: A boolean value that determines whether the subviews layout should be `left to right`.
    public convenience init(frame: NSRect = .zero, leftToRight: Bool = true) {
        self.init(frame: frame)
        self.leftToRight = leftToRight
        self.load()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented. Use `init(frame:) instead.`")
    }
    
    /// Load content subviews.
    ///
    /// You should never call this function manually since this is automatically called on `init(frame:)`.
    public func load() {
        imageView = NSImageView(frame: .zero)
        imageView.imageScaling = .scaleProportionallyDown
        
        titleView = ScrollingTextView(frame: .zero)
        titleView.font = NSFont.systemFont(ofSize: 9)
        if !canScrollTitle { titleView.speed = 0 }
        
        subtitleView = ScrollingTextView(frame: .zero)
        subtitleView.font = NSFont.systemFont(ofSize: 9)
        subtitleView.textColor = NSColor(calibratedRed: 124/255, green: 131/255, blue: 127/255, alpha: 1)
        if !canScrollSubtitle { subtitleView.speed = 0 }
        
        addSubview(imageView)
        addSubview(titleView)
        addSubview(subtitleView)
        
        updateConstraint()
        didLoad()
    }
    
    // MARK: Overrideables
    
    /// Override this function to do your custom initial setup.
    open func didLoad() {
        /// do your implementation
    }
    
    /// Override this function to layout subviews as you prefer.
    ///
    /// `SnapKit` can help you in doing this.
    open func updateConstraint() {
        if leftToRight {
            imageView.snp.remakeConstraints({ maker in
                maker.width.equalTo(shouldHideIcon ? 0 : 24)
                maker.top.bottom.equalTo(self)
                maker.left.equalTo(self)
            })
            titleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.height.equalTo(self).dividedBy(2)
                maker.left.equalTo(imageView.snp.right).offset(4)
                maker.top.equalTo(self).inset(2)
                maker.right.equalToSuperview().inset(4)
            })
            subtitleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.left.equalTo(titleView)
                maker.top.equalTo(titleView.snp.bottom).inset(3)
                maker.right.equalTo(titleView)
                maker.bottom.greaterThanOrEqualTo(self)
            })
        }else {
            titleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.height.equalTo(self).dividedBy(2)
                maker.left.equalToSuperview()
                maker.top.equalTo(self).inset(2)
            })
            subtitleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.top.equalTo(titleView.snp.bottom).inset(3)
                maker.left.equalTo(titleView)
                maker.bottom.greaterThanOrEqualTo(self)
            })
            imageView.snp.remakeConstraints({ maker in
                maker.width.equalTo(shouldHideIcon ? 0 : 24)
                maker.top.bottom.equalTo(self)
                maker.right.equalTo(self)
                maker.left.equalTo((titleView.frame.width > subtitleView.frame.width ? titleView : subtitleView).snp.right).offset(4)
            })
        }
    }
    
    // MARK: Setters
    
    /// Set text for `titleView`
    ///
    /// - parameter title: The text to set to `titleView`.
    open func set(title: String?) {
        titleView.setup(string: title ?? "")
    }
    
    /// Set text for `subtitleView`
    ///
    /// - parameter subtitle: The text to set to `subtitleView`.
    open func set(subtitle: String?) {
        subtitleView.setup(string: subtitle ?? "")
    }
    
    /// Set image for `imageView`
    ///
    /// - parameter image: The image to set to `imageView`.
    open func set(image: NSImage?) {
        imageView?.image = image
    }
    
}

// MARK: Bounce animation
extension PKDetailView {
    
    /// Start `imageView`'s bouncing scale animation.
    public func startBounceAnimation() {
        if !isAnimating {
            self.loadBounceAnimation()
        }
    }
    
    /// Stop `imageView`'s bouncing scale animation.
    public func stopBounceAnimation() {
        self.imageView.layer?.removeAnimation(forKey: PKDetailView.kBounceAnimationKey)
        self.isAnimating = false
    }
    
    /// Prepare `imageView`'s boucing scale animation.
    private func loadBounceAnimation() {
        isAnimating                   = true
        
        let bounce                   = CABasicAnimation(keyPath: "transform.scale")
        bounce.fromValue             = 0.86
        bounce.toValue               = 1
        bounce.duration              = 1.2
        bounce.autoreverses          = true
        bounce.repeatCount           = Float.infinity
        bounce.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let frame = self.imageView.layer?.frame
        self.imageView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.imageView.layer?.frame = frame ?? .zero
        self.imageView.layer?.add(bounce, forKey: PKDetailView.kBounceAnimationKey)
    }
    
}

