# AJVIPLaunchScreen

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/ChinaArJun/aj_vip_launch_screen)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B-lightgrey.svg)](https://github.com/ChinaArJun/aj_vip_launch_screen)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A beautiful, customizable launch screen library for iOS applications with multiple pre-designed styles and smooth animations.

## Features

✨ **Multiple Styles** - Choose from beautifully designed launch screen styles
- **METRO X**: Tech-focused subway theme with animated logo and onboarding slides
- **Balloon**: Playful purple gradient theme with floating balloon animation

🎨 **Customizable** - Easily customize colors, content, and behavior

🌍 **Localization** - Built-in support for English and Chinese

⚡ **Easy Integration** - Simple CocoaPods installation and one-line setup

🎭 **Smooth Animations** - Professional animations and transitions

## Screenshots

### Style 1: METRO X
<table>
  <tr>
    <td>Splash Screen</td>
    <td>Onboarding</td>
    <td>Subscription</td>
  </tr>
</table>

### Style 2: Balloon
<table>
  <tr>
    <td>Launch Screen</td>
  </tr>
</table>

## Installation

### CocoaPods

Add the following line to your `Podfile`:

```ruby
pod 'AJVIPLaunchScreen', '~> 1.0'
```

For local development:

```ruby
pod 'AJVIPLaunchScreen', :path => './AJVIPLaunchScreen'
```

Then run:

```bash
pod install
```

## Quick Start

### Basic Usage

```swift
import AJVIPLaunchScreen

// In your SceneDelegate or AppDelegate
let configuration = AJLaunchScreenConfiguration(style: .metroX)
AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
```

### With Delegate Callbacks

```swift
import AJVIPLaunchScreen

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AJLaunchScreenDelegate {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        var configuration = AJLaunchScreenConfiguration(style: .balloon)
        configuration.delegate = self
        
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
    
    // MARK: - AJLaunchScreenDelegate
    
    func launchScreenDidComplete() {
        // User completed onboarding
        // Navigate to main app
        let mainVC = MainViewController()
        window?.rootViewController = mainVC
    }
    
    func launchScreenDidSkip() {
        // User skipped onboarding
        let mainVC = MainViewController()
        window?.rootViewController = mainVC
    }
    
    func launchScreenDidSelectSubscription() {
        // User selected subscription
        // Handle subscription flow
    }
}
```

## Customization

### Custom Colors

```swift
let configuration = AJLaunchScreenConfiguration(
    style: .metroX,
    primaryColor: UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 1.0)
)
```

### Hide Skip Button

```swift
let configuration = AJLaunchScreenConfiguration(
    style: .balloon,
    showSkipButton: false
)
```

### Custom Animation Duration

```swift
let configuration = AJLaunchScreenConfiguration(
    style: .metroX,
    animationDuration: 1.0
)
```

### Custom Slides (METRO X Style)

```swift
let customSlides = [
    AJSlideData(
        title: "Welcome",
        description: "Get started with our amazing app",
        iconName: "star.fill",
        color: .systemBlue
    ),
    AJSlideData(
        title: "Discover",
        description: "Explore powerful features",
        iconName: "sparkles",
        color: .systemPurple
    )
]

let configuration = AJLaunchScreenConfiguration(
    style: .metroX,
    customSlides: customSlides
)
```

## Available Styles

### METRO X (.metroX)

A tech-focused theme featuring:
- Animated logo splash screen
- 3 onboarding slides with parallax backgrounds
- Smooth background transitions
- Subscription page with glassmorphism effect
- Perfect for: Transit apps, tech products, professional services

### Balloon (.balloon)

A playful theme featuring:
- Purple gradient background
- Animated floating balloon with cute face
- Twinkling stars
- Wavy bottom section
- Chinese localization support
- Perfect for: Consumer apps, lifestyle products, subscription services

## Localization

The library includes built-in localization for:
- English (en)
- Simplified Chinese (zh-Hans)

To add custom localizations, provide your own `Localizable.strings` files in your app bundle.

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 12.0+

## Architecture

```
AJVIPLaunchScreen/
├── Classes/
│   ├── Core/
│   │   ├── AJLaunchScreenManager.swift      # Main entry point
│   │   ├── AJLaunchScreenStyle.swift        # Style enum
│   │   └── AJLaunchScreenConfiguration.swift # Configuration
│   ├── Styles/
│   │   ├── MetroX/                          # METRO X implementation
│   │   └── Balloon/                         # Balloon implementation
│   └── Common/
│       ├── AJSlideData.swift                # Data model
│       └── AJLaunchScreenDelegate.swift     # Delegate protocol
└── Assets/
    ├── MetroX.xcassets/                     # METRO X assets
    └── Balloon.xcassets/                    # Balloon assets
```

## API Reference

### AJLaunchScreenManager

```swift
class AJLaunchScreenManager {
    static let shared: AJLaunchScreenManager
    
    func present(in window: UIWindow?, configuration: AJLaunchScreenConfiguration)
    func present(from viewController: UIViewController, configuration: AJLaunchScreenConfiguration, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
```

### AJLaunchScreenConfiguration

```swift
struct AJLaunchScreenConfiguration {
    let style: AJLaunchScreenStyle
    let showSkipButton: Bool
    let animationDuration: TimeInterval
    let primaryColor: UIColor?
    let customSlides: [AJSlideData]?
    weak var delegate: AJLaunchScreenDelegate?
}
```

### AJLaunchScreenDelegate

```swift
protocol AJLaunchScreenDelegate: AnyObject {
    func launchScreenDidComplete()
    func launchScreenDidSkip()
    func launchScreenDidSelectSubscription()
}
```

## Example Project

To run the example project:

```bash
cd Example
pod install
open AJVIPLaunchScreenDemo.xcworkspace
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

AJVIPLaunchScreen is available under the MIT license. See the LICENSE file for more info.

## Author

Arjun - [GitHub](https://github.com/ChinaArJun)

## Changelog

### 1.0.0 (2025-11-25)
- Initial release
- METRO X style implementation
- Balloon style implementation
- English and Chinese localization
- Customization options
- Delegate callbacks
