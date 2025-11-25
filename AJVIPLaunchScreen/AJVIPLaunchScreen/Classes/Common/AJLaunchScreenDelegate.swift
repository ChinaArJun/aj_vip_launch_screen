//
//  AJLaunchScreenDelegate.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import Foundation

/// Delegate protocol for launch screen events
public protocol AJLaunchScreenDelegate: AnyObject {
    /// Called when user completes the onboarding flow
    func launchScreenDidComplete()
    
    /// Called when user skips the onboarding
    func launchScreenDidSkip()
    
    /// Called when user selects subscription option
    func launchScreenDidSelectSubscription()
}

// Optional methods
public extension AJLaunchScreenDelegate {
    func launchScreenDidSkip() {}
    func launchScreenDidSelectSubscription() {}
}
