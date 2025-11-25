//
//  AJBalloonLaunchViewController.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

class AJBalloonLaunchViewController: UIViewController {
    
    // MARK: - Properties
    private let configuration: AJLaunchScreenConfiguration
    
    // MARK: - UI Components
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        // Purple gradient from darker top to lighter bottom
        layer.colors = [
            UIColor(red: 78/255, green: 84/255, blue: 200/255, alpha: 1.0).cgColor,
            UIColor(red: 143/255, green: 148/255, blue: 251/255, alpha: 1.0).cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private lazy var balloonView: AJBalloonAnimationView = {
        let view = AJBalloonAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var starViews: [UIImageView] = []
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let appStoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "App Store"
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = UIColor.white.withAlphaComponent(0.8)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Wavy bottom section
    private let bottomWaveView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let featureLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0)
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return btn
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "arrow.right"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let continueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = NSLocalizedString("继续", comment: "Continue")
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let termsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let trialLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 11)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Initialization
    init(configuration: AJLaunchScreenConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupStars()
        setupUI()
        setupLocalizedText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        drawWavyShape()
    }
    
    // MARK: - Setup
    private func setupGradient() {
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupStars() {
        let bundle = Bundle(for: type(of: self))
        let starImage = UIImage(named: "star_white", in: bundle, compatibleWith: nil) ?? createStarImage()
        
        // Star positions and sizes based on design
        let starConfigs: [(x: CGFloat, y: CGFloat, size: CGFloat, alpha: CGFloat)] = [
            (0.15, 0.15, 40, 1.0),   // Large star top-left
            (0.75, 0.12, 30, 1.0),   // Medium star top-right
            (0.25, 0.32, 20, 0.8)    // Small star middle-left
        ]
        
        for config in starConfigs {
            let starView = UIImageView(image: starImage)
            starView.contentMode = .scaleAspectFit
            starView.alpha = config.alpha
            starView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(starView)
            
            NSLayoutConstraint.activate([
                starView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * config.x),
                starView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * config.y),
                starView.widthAnchor.constraint(equalToConstant: config.size),
                starView.heightAnchor.constraint(equalToConstant: config.size)
            ])
            
            starViews.append(starView)
            animateStar(starView)
        }
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(appStoreLabel)
        view.addSubview(balloonView)
        view.addSubview(bottomWaveView)
        view.addSubview(bottomContentView)
        bottomContentView.addSubview(featureLabel)
        bottomContentView.addSubview(continueButton)
        continueButton.addSubview(continueLabel)
        continueButton.addSubview(arrowImageView)
        bottomContentView.addSubview(termsStackView)
        bottomContentView.addSubview(trialLabel)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            appStoreLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            appStoreLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 8),
            
            balloonView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            balloonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            balloonView.widthAnchor.constraint(equalToConstant: 200),
            balloonView.heightAnchor.constraint(equalToConstant: 240),
            
            bottomWaveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomWaveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomWaveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomWaveView.heightAnchor.constraint(equalToConstant: 400),
            
            bottomContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContentView.heightAnchor.constraint(equalToConstant: 350),
            
            featureLabel.topAnchor.constraint(equalTo: bottomContentView.topAnchor, constant: 60),
            featureLabel.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: 40),
            featureLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor, constant: -40),
            
            continueButton.bottomAnchor.constraint(equalTo: trialLabel.topAnchor, constant: -20),
            continueButton.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: 32),
            continueButton.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            
            continueLabel.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            continueLabel.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            trialLabel.bottomAnchor.constraint(equalTo: termsStackView.topAnchor, constant: -8),
            trialLabel.centerXAnchor.constraint(equalTo: bottomContentView.centerXAnchor),
            
            termsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            termsStackView.centerXAnchor.constraint(equalTo: bottomContentView.centerXAnchor),
            termsStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        setupTermsLinks()
    }
    
    private func setupLocalizedText() {
        // Feature description
        let featureText = NSLocalizedString("海拔、气压、方位、磁场、风向等\n专业测量精准掌控", comment: "Feature description")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        
        let attrString = NSAttributedString(string: featureText, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ])
        featureLabel.attributedText = attrString
        
        // Trial info
        trialLabel.text = NSLocalizedString("免费试用3天，之后¥66.00/周，自动续订，随时取消", comment: "Trial info")
    }
    
    private func setupTermsLinks() {
        let linkTexts = [
            NSLocalizedString("服务条款", comment: "Terms of Service"),
            NSLocalizedString("隐私政策", comment: "Privacy Policy"),
            NSLocalizedString("恢复购买", comment: "Restore Purchase")
        ]
        
        for text in linkTexts {
            let btn = UIButton(type: .system)
            btn.setTitle(text, for: .normal)
            btn.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            termsStackView.addArrangedSubview(btn)
        }
    }
    
    private func drawWavyShape() {
        bottomWaveView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let path = UIBezierPath()
        let width = bottomWaveView.bounds.width
        let height = bottomWaveView.bounds.height
        
        // Start from top-left
        path.move(to: CGPoint(x: 0, y: 50))
        
        // Create wave using curves
        path.addCurve(
            to: CGPoint(x: width, y: 50),
            controlPoint1: CGPoint(x: width * 0.25, y: 0),
            controlPoint2: CGPoint(x: width * 0.75, y: 100)
        )
        
        // Complete the shape
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        
        bottomWaveView.layer.addSublayer(shapeLayer)
    }
    
    private func animateStar(_ starView: UIImageView) {
        let twinkle = CAKeyframeAnimation(keyPath: "opacity")
        twinkle.values = [1.0, 0.3, 1.0, 0.5, 1.0]
        twinkle.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        twinkle.duration = Double.random(in: 2.0...4.0)
        twinkle.repeatCount = .infinity
        
        starView.layer.add(twinkle, forKey: "twinkling")
    }
    
    private func createStarImage() -> UIImage {
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let path = UIBezierPath()
            let center = CGPoint(x: 20, y: 20)
            let outerRadius: CGFloat = 18
            let innerRadius: CGFloat = 8
            let points = 5
            
            for i in 0..<points * 2 {
                let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            path.close()
            UIColor.white.setFill()
            path.fill()
        }
    }
    
    // MARK: - Actions
    @objc private func handleContinue() {
        configuration.delegate?.launchScreenDidComplete()
        AJLaunchScreenManager.shared.dismiss(animated: true)
    }
    
    @objc private func handleClose() {
        configuration.delegate?.launchScreenDidSkip()
        AJLaunchScreenManager.shared.dismiss(animated: true)
    }
}
