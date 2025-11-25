//
//  DemoSceneDelegate.swift
//  demo
//
//  演示如何在实际项目中使用 AJVIPLaunchScreen Pod
//  将此文件内容复制到 SceneDelegate.swift 即可使用
//

import UIKit
// 注意：使用前需要先运行 pod install
// import AJVIPLaunchScreen

class DemoSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // ==========================================
        // 使用案例选择（取消注释想要测试的案例）
        // ==========================================
        
        // 案例 1: Balloon 风格（推荐首次使用）
        showBalloonStyle()
        
        // 案例 2: METRO X 风格
        // showMetroXStyle()
        
        // 案例 3: 自定义颜色的 METRO X
        // showCustomColorMetroX()
        
        // 案例 4: 完全自定义内容
        // showCustomContent()
        
        // 案例 5: 首次启动检测
        // showOnboardingIfNeeded()
    }
    
    // MARK: - 案例 1: Balloon 风格（气球主题）
    /// 特点：紫色渐变、可爱气球动画、闪烁星星、中文界面
    private func showBalloonStyle() {
        // 取消下面的注释以使用 Pod
        /*
        var configuration = AJLaunchScreenConfiguration(style: .balloon)
        configuration.delegate = self
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
        */
        
        // 临时方案：使用现有的 ViewController
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    // MARK: - 案例 2: METRO X 风格（科技主题）
    /// 特点：动画 Logo、引导页面、背景过渡、订阅页面
    private func showMetroXStyle() {
        /*
        var configuration = AJLaunchScreenConfiguration(style: .metroX)
        configuration.delegate = self
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
        */
    }
    
    // MARK: - 案例 3: 自定义颜色
    /// 使用自定义主题色的 METRO X 风格
    private func showCustomColorMetroX() {
        /*
        var configuration = AJLaunchScreenConfiguration(
            style: .metroX,
            primaryColor: UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 1.0)
        )
        configuration.delegate = self
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
        */
    }
    
    // MARK: - 案例 4: 完全自定义内容
    /// 自定义引导页面的标题、描述、图标和颜色
    private func showCustomContent() {
        /*
        let customSlides = [
            AJSlideData(
                title: "欢迎使用",
                description: "开启您的精彩旅程",
                iconName: "star.fill",
                color: UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0)
            ),
            AJSlideData(
                title: "强大功能",
                description: "体验前所未有的便捷",
                iconName: "bolt.fill",
                color: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
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
        */
    }
    
    // MARK: - 案例 5: 首次启动检测
    /// 只在首次启动时显示引导，之后直接进入主应用
    private func showOnboardingIfNeeded() {
        if isFirstLaunch() {
            showBalloonStyle()
        } else {
            showMainApp()
        }
    }
    
    // MARK: - Helper Methods
    
    /// 检查是否首次启动
    private func isFirstLaunch() -> Bool {
        let key = "HasLaunchedBefore"
        let hasLaunched = UserDefaults.standard.bool(forKey: key)
        
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: key)
            return true
        }
        return false
    }
    
    /// 显示主应用界面
    private func showMainApp() {
        let mainVC = createMainViewController()
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }
    
    /// 创建主界面视图控制器
    private func createMainViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "主应用界面"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle("重新查看引导", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showOnboardingAgain), for: .touchUpInside)
        
        vc.view.addSubview(label)
        vc.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -30),
            
            button.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
        
        return vc
    }
    
    @objc private func showOnboardingAgain() {
        // 重新显示引导页面
        showBalloonStyle()
    }
}

// MARK: - AJLaunchScreenDelegate
/*
extension DemoSceneDelegate: AJLaunchScreenDelegate {
    
    /// 用户完成了引导流程
    func launchScreenDidComplete() {
        print("✅ 用户完成引导")
        
        // 保存完成状态
        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
        
        // 显示主应用
        showMainApp()
    }
    
    /// 用户跳过了引导
    func launchScreenDidSkip() {
        print("⏭️ 用户跳过引导")
        showMainApp()
    }
    
    /// 用户选择了订阅
    func launchScreenDidSelectSubscription() {
        print("💳 用户点击订阅")
        
        // 处理订阅逻辑
        AJLaunchScreenManager.shared.dismiss(animated: true) {
            self.handleSubscription()
        }
    }
    
    private func handleSubscription() {
        // 这里实现订阅逻辑
        // 例如：显示订阅页面或调用 StoreKit
        
        let alert = UIAlertController(
            title: "订阅服务",
            message: "这里可以集成您的订阅流程",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            self.showMainApp()
        })
        
        window?.rootViewController?.present(alert, animated: true)
    }
}
*/

// MARK: - 使用说明
/*
 
 📝 如何使用此演示代码：
 
 1. 安装 Pod
    在项目根目录运行：
    $ pod install
 
 2. 打开工作空间
    $ open demo.xcworkspace
 
 3. 替换 SceneDelegate
    将 SceneDelegate.swift 的内容替换为此文件的内容
    或者直接修改 SceneDelegate.swift 的 scene(_:willConnectTo:options:) 方法
 
 4. 取消注释
    - 取消 import AJVIPLaunchScreen 的注释
    - 取消想要测试的案例代码的注释
    - 取消 AJLaunchScreenDelegate 扩展的注释
 
 5. 运行项目
    Command + R 运行查看效果
 
 💡 提示：
 - Balloon 风格适合消费类应用
 - METRO X 风格适合科技类应用
 - 可以通过 configuration 自定义颜色和内容
 - 使用 delegate 处理用户交互
 
 */
