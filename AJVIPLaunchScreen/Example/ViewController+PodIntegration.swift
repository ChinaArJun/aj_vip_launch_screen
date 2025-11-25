//
//  ViewController+PodIntegration.swift
//  demo
//
//  演示如何将现有的 ViewController 改造为使用 AJVIPLaunchScreen Pod
//
//  使用方法：
//  1. 运行 pod install
//  2. 在 SceneDelegate 中使用 Pod 替代直接使用 ViewController
//

import UIKit
// import AJVIPLaunchScreen  // 取消注释以使用 Pod

// MARK: - 方案 1: 在 SceneDelegate 中使用 Pod（推荐）
/*
 
 在 SceneDelegate.swift 中：
 
 import UIKit
 import AJVIPLaunchScreen
 
 class SceneDelegate: UIResponder, UIWindowSceneDelegate, AJLaunchScreenDelegate {
     
     var window: UIWindow?
     
     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
                options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = (scene as? UIWindowScene) else { return }
         
         let window = UIWindow(windowScene: windowScene)
         self.window = window
         
         // 使用 METRO X 风格（与现有 ViewController 相同的效果）
         var configuration = AJLaunchScreenConfiguration(style: .metroX)
         configuration.delegate = self
         
         AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
     }
     
     // MARK: - Delegate
     func launchScreenDidComplete() {
         // 进入主应用
         let mainVC = MainViewController()
         window?.rootViewController = mainVC
         window?.makeKeyAndVisible()
     }
     
     func launchScreenDidSkip() {
         let mainVC = MainViewController()
         window?.rootViewController = mainVC
         window?.makeKeyAndVisible()
     }
 }
 
 */

// MARK: - 方案 2: 在 ViewController 中切换风格
extension ViewController {
    
    /// 演示：从当前 ViewController 切换到 Pod 的不同风格
    func showLaunchScreenStyles() {
        // 创建一个设置页面，让用户选择风格
        let settingsVC = LaunchScreenStyleSelector()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
    }
}

// MARK: - 风格选择器示例
class LaunchScreenStyleSelector: UIViewController {
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "选择启动屏幕风格"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        // METRO X 按钮
        let metroXButton = createStyleButton(
            title: "METRO X 风格",
            subtitle: "科技主题 · 动画Logo · 引导页面",
            color: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0),
            action: #selector(showMetroXStyle)
        )
        
        // Balloon 按钮
        let balloonButton = createStyleButton(
            title: "Balloon 风格",
            subtitle: "气球主题 · 紫色渐变 · 可爱动画",
            color: UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0),
            action: #selector(showBalloonStyle)
        )
        
        // 自定义按钮
        let customButton = createStyleButton(
            title: "自定义风格",
            subtitle: "自定义颜色 · 自定义内容",
            color: UIColor.systemPurple,
            action: #selector(showCustomStyle)
        )
        
        // 关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(metroXButton)
        stackView.addArrangedSubview(balloonButton)
        stackView.addArrangedSubview(customButton)
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 360),
            
            closeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createStyleButton(title: String, subtitle: String, color: UIColor, action: Selector) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.1)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = color.cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = color
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    @objc private func showMetroXStyle() {
        // 取消注释以使用 Pod
        /*
        dismiss(animated: true) {
            var configuration = AJLaunchScreenConfiguration(style: .metroX)
            configuration.delegate = self
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
            }
        }
        */
        
        // 临时方案：显示当前的 ViewController
        dismiss(animated: true) {
            let vc = ViewController()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }
        }
    }
    
    @objc private func showBalloonStyle() {
        // 取消注释以使用 Pod
        /*
        dismiss(animated: true) {
            var configuration = AJLaunchScreenConfiguration(style: .balloon)
            configuration.delegate = self
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
            }
        }
        */
        
        showAlert(title: "Balloon 风格", message: "请先运行 pod install 并导入 AJVIPLaunchScreen")
    }
    
    @objc private func showCustomStyle() {
        // 取消注释以使用 Pod
        /*
        dismiss(animated: true) {
            let customSlides = [
                AJSlideData(
                    title: "欢迎使用",
                    description: "开启您的精彩旅程",
                    iconName: "star.fill",
                    color: UIColor.systemOrange
                ),
                AJSlideData(
                    title: "强大功能",
                    description: "体验前所未有的便捷",
                    iconName: "bolt.fill",
                    color: UIColor.systemBlue
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
                primaryColor: UIColor.systemPink,
                customSlides: customSlides
            )
            configuration.delegate = self
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
            }
        }
        */
        
        showAlert(title: "自定义风格", message: "请先运行 pod install 并导入 AJVIPLaunchScreen")
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

/*
// 取消注释以使用 Pod
extension LaunchScreenStyleSelector: AJLaunchScreenDelegate {
    func launchScreenDidComplete() {
        // 返回主应用
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let mainVC = MainViewController()
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
        }
    }
    
    func launchScreenDidSkip() {
        launchScreenDidComplete()
    }
}
*/

// MARK: - 主应用视图控制器示例
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "主应用界面"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.setTitle("查看启动屏幕风格", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStyleSelector), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func showStyleSelector() {
        let selector = LaunchScreenStyleSelector()
        selector.modalPresentationStyle = .fullScreen
        present(selector, animated: true)
    }
}

// MARK: - 使用说明
/*
 
 📝 集成步骤：
 
 1️⃣ 安装 Pod
    $ cd /Users/arjun/code/ios/demo
    $ pod install
    $ open demo.xcworkspace
 
 2️⃣ 修改 SceneDelegate.swift
    将 scene(_:willConnectTo:options:) 方法改为：
 
    import AJVIPLaunchScreen
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // 方式 1: 使用 METRO X 风格（与现有 ViewController 相同）
        var configuration = AJLaunchScreenConfiguration(style: .metroX)
        configuration.delegate = self
        AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
        
        // 方式 2: 使用 Balloon 风格
        // var configuration = AJLaunchScreenConfiguration(style: .balloon)
        // configuration.delegate = self
        // AJLaunchScreenManager.shared.present(in: window, configuration: configuration)
    }
 
 3️⃣ 实现代理方法
    extension SceneDelegate: AJLaunchScreenDelegate {
        func launchScreenDidComplete() {
            let mainVC = MainViewController()
            window?.rootViewController = mainVC
            window?.makeKeyAndVisible()
        }
    }
 
 4️⃣ 运行项目
    Command + R
 
 💡 优势：
 - ✅ 不需要维护 ViewController.swift 中的 500+ 行代码
 - ✅ 可以轻松切换风格（.metroX / .balloon）
 - ✅ 可以自定义颜色和内容
 - ✅ 可以在多个项目中复用
 - ✅ 统一的 API 和配置方式
 
 */
