//
//  ExampleSceneDelegate.swift
//  AJVIPLaunchScreen Example
//
//  演示如何在 SceneDelegate 中集成启动屏幕
//

import UIKit
import AJVIPLaunchScreen

class ExampleSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // 检查是否是首次启动
        if isFirstLaunch() {
            // 首次启动显示启动屏幕
            showLaunchScreen()
        } else {
            // 非首次启动直接进入主界面
            showMainApp()
        }
    }
    
    // MARK: - 示例 1: 基础使用 - Balloon 风格
    private func showLaunchScreen() {
        var configuration = AJLaunchScreenConfiguration(style: .balloon)
        configuration.delegate = self
        
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
    
    // MARK: - 示例 2: METRO X 风格带自定义颜色
    private func showMetroXStyle() {
        var configuration = AJLaunchScreenConfiguration(
            style: .metroX,
            showSkipButton: true,
            animationDuration: 0.8,
            primaryColor: UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 1.0)
        )
        configuration.delegate = self
        
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
    
    // MARK: - 示例 3: 自定义内容的 METRO X 风格
    private func showCustomMetroX() {
        let customSlides = [
            AJSlideData(
                title: "欢迎使用",
                description: "开启您的精彩旅程，探索更多可能性",
                iconName: "star.fill",
                color: UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0)
            ),
            AJSlideData(
                title: "强大功能",
                description: "体验前所未有的便捷服务，让生活更简单",
                iconName: "bolt.fill",
                color: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
            ),
            AJSlideData(
                title: "安全可靠",
                description: "银行级加密保护，您的数据安全无忧",
                iconName: "lock.shield.fill",
                color: UIColor(red: 0/255, green: 255/255, blue: 170/255, alpha: 1.0)
            ),
            AJSlideData(
                title: "立即开始",
                description: "",
                iconName: "star.fill",
                color: .white
            )
        ]
        
        var configuration = AJLaunchScreenConfiguration(
            style: .metroX,
            customSlides: customSlides
        )
        configuration.delegate = self
        
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
    
    // MARK: - 示例 4: 隐藏跳过按钮的 Balloon 风格
    private func showBalloonNoSkip() {
        var configuration = AJLaunchScreenConfiguration(
            style: .balloon,
            showSkipButton: false
        )
        configuration.delegate = self
        
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
    
    // MARK: - Helper Methods
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "HasLaunchedBefore"
        let hasLaunched = UserDefaults.standard.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            return true
        }
        return false
    }
    
    private func showMainApp() {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - AJLaunchScreenDelegate
extension ExampleSceneDelegate: AJLaunchScreenDelegate {
    
    func launchScreenDidComplete() {
        print("✅ 用户完成了启动引导")
        
        // 保存用户已完成引导的状态
        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
        
        // 显示主应用界面
        showMainApp()
    }
    
    func launchScreenDidSkip() {
        print("⏭️ 用户跳过了启动引导")
        
        // 显示主应用界面
        showMainApp()
    }
    
    func launchScreenDidSelectSubscription() {
        print("💳 用户选择了订阅")
        
        // 处理订阅逻辑
        handleSubscription()
    }
    
    private func handleSubscription() {
        // 这里实现您的订阅逻辑
        // 例如：调用 StoreKit 进行应用内购买
        
        // 示例：显示订阅详情页
        let subscriptionVC = SubscriptionViewController()
        
        // 先关闭启动屏幕
        AJLaunchScreenManager.shared.dismiss(animated: true) {
            // 然后显示订阅页面
            let navController = UINavigationController(rootViewController: subscriptionVC)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
    }
}

// MARK: - 占位视图控制器
class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "主页"
        
        let label = UILabel()
        label.text = "欢迎使用应用！"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class SubscriptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "订阅服务"
        
        let label = UILabel()
        label.text = "订阅详情页面"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
