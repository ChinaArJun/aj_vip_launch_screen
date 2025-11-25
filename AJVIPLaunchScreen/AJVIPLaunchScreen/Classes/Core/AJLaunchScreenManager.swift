//
//  AJLaunchScreenManager.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

/// Main manager class for presenting launch screens
public class AJLaunchScreenManager {
    
    /// Shared singleton instance
    public static let shared = AJLaunchScreenManager()
    
    private var currentViewController: UIViewController?
    
    private init() {}
    
    /// Present launch screen in the given window
    /// - Parameters:
    ///   - window: The window to present in
    ///   - configuration: Configuration for the launch screen
    public func present(in window: UIWindow?, configuration: AJLaunchScreenConfiguration) {
        guard let window = window else { return }
        
        let viewController = createViewController(for: configuration)
        currentViewController = viewController
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    /// Present launch screen from a view controller
    /// - Parameters:
    ///   - viewController: The presenting view controller
    ///   - configuration: Configuration for the launch screen
    ///   - animated: Whether to animate the presentation
    public func present(from viewController: UIViewController, configuration: AJLaunchScreenConfiguration, animated: Bool = true) {
        let launchVC = createViewController(for: configuration)
        currentViewController = launchVC
        
        launchVC.modalPresentationStyle = .fullScreen
        viewController.present(launchVC, animated: animated)
    }
    
    /// Dismiss the current launch screen
    /// - Parameter completion: Completion handler
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        currentViewController?.dismiss(animated: animated, completion: completion)
        currentViewController = nil
    }
    
    // MARK: - Private Methods
    
    private func createViewController(for configuration: AJLaunchScreenConfiguration) -> UIViewController {
        switch configuration.style {
        case .metroX:
            return AJMetroXLaunchViewController(configuration: configuration)
        case .balloon:
            return AJBalloonLaunchViewController(configuration: configuration)
        }
    }
}
