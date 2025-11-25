Pod::Spec.new do |s|
  s.name             = 'AJVIPLaunchScreen'
  s.version          = '1.0.0'
  s.summary          = 'A customizable launch screen library with multiple beautiful styles for iOS apps.'
  s.description      = <<-DESC
AJVIPLaunchScreen provides elegant, animated launch screens for iOS applications.
Features include:
- Multiple pre-designed styles (METRO X tech theme, Balloon playful theme)
- Smooth animations and transitions
- Easy integration via CocoaPods
- Customizable colors and content
- Localization support (English and Chinese)
- Delegate callbacks for user interactions
                       DESC

  s.homepage         = 'https://github.com/ChinaArJun/aj_vip_launch_screen'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arjun' => 'your.email@example.com' }
  s.source           = { :git => 'https://github.com/ChinaArJun/aj_vip_launch_screen.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'AJVIPLaunchScreen/Classes/**/*.swift'
  
  s.resource_bundles = {
    'AJVIPLaunchScreen' => ['AJVIPLaunchScreen/Assets/**/*.{png,xcassets}']
  }

  s.frameworks = 'UIKit'
end
