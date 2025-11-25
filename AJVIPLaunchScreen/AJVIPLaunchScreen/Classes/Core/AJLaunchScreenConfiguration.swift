//
//  AJLaunchScreenConfiguration.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

/// Configuration for launch screen presentation
public struct AJLaunchScreenConfiguration {
    /// The visual style to use
    public let style: AJLaunchScreenStyle
    
    /// Whether to show skip button (default: true)
    public let showSkipButton: Bool
    
    /// Animation duration for transitions (default: 0.5)
    public let animationDuration: TimeInterval
    
    /// Custom primary color (optional, uses style default if nil)
    public let primaryColor: UIColor?
    
    /// Custom slides data (optional, uses style default if nil)
    public let customSlides: [AJSlideData]?
    
    /// Delegate for callbacks
    public weak var delegate: AJLaunchScreenDelegate?
    
    public init(
        style: AJLaunchScreenStyle,
        showSkipButton: Bool = true,
        animationDuration: TimeInterval = 0.5,
        primaryColor: UIColor? = nil,
        customSlides: [AJSlideData]? = nil,
        delegate: AJLaunchScreenDelegate? = nil
    ) {
        self.style = style
        self.showSkipButton = showSkipButton
        self.animationDuration = animationDuration
        self.primaryColor = primaryColor
        self.customSlides = customSlides
        self.delegate = delegate
    }
}
