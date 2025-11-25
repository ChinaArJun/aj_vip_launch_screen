//
//  ViewController.swift
//  demo
//
//  Created by arjun on 2025/11/25.
//

import UIKit

// MARK: - Data Model
struct SlideData {
    let title: String
    let description: String
    let iconName: String
    let color: UIColor
}

// MARK: - Main View Controller
class ViewController: UIViewController {

    // MARK: - Properties
    private let slides: [SlideData] = [
        SlideData(title: "Real-Time\nPrecision", description: "Live tracking of every train in the network. Know exactly when to arrive, down to the second.", iconName: "location.circle.fill", color: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)),
        SlideData(title: "Smart\nNavigation", description: "AR-powered guidance through complex interchanges. Never get lost in the underground again.", iconName: "map.fill", color: UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1.0)),
        SlideData(title: "Seamless\nAccess", description: "Tap to pay with NFC. Integrated digital tickets for all major transit lines worldwide.", iconName: "wave.3.right.circle.fill", color: UIColor(red: 0/255, green: 255/255, blue: 170/255, alpha: 1.0)),
        SlideData(title: "Upgrade Your\nJourney", description: "", iconName: "star.fill", color: .white) // Subscription slide
    ]
    
    // Backgrounds
    private var backgroundViews: [UIImageView] = []
    private let backgroundImages = ["bg_speed", "bg_nodes", "bg_speed", "bg_glass"] // Assets must exist
    
    // UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        cv.register(SubscriptionCell.self, forCellWithReuseIdentifier: "SubscriptionCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = slides.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 28
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return btn
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return btn
    }()
    
    // Splash Screen
    private lazy var splashView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var splashLogo: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0).cgColor
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var splashText: UILabel = {
        let lbl = UILabel()
        let attrString = NSMutableAttributedString(string: "METRO X", attributes: [
            .font: UIFont.systemFont(ofSize: 40, weight: .bold),
            .foregroundColor: UIColor.white,
            .kern: 2.0
        ])
        attrString.addAttribute(.foregroundColor, value: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0), range: NSRange(location: 6, length: 1))
        lbl.attributedText = attrString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.alpha = 0
        return lbl
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSplash()
    }
    
    // MARK: - Setup
    private func setupBackgrounds() {
        view.backgroundColor = .black
        
        for (index, imageName) in backgroundImages.enumerated() {
            let iv = UIImageView(image: UIImage(named: imageName))
            iv.contentMode = .scaleAspectFill
            iv.frame = view.bounds
            iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            iv.alpha = index == 0 ? 1 : 0 // Only first one visible initially
            view.insertSubview(iv, at: index)
            backgroundViews.append(iv)
            
            // Add overlay gradient
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.black.withAlphaComponent(0.1).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
            gradient.locations = [0.0, 1.0]
            iv.layer.addSublayer(gradient)
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
        // Splash setup
        view.addSubview(splashView)
        splashView.addSubview(splashLogo)
        splashView.addSubview(splashText)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 56),
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Splash
            splashView.topAnchor.constraint(equalTo: view.topAnchor),
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            splashLogo.centerXAnchor.constraint(equalTo: splashView.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: splashView.centerYAnchor, constant: -40),
            splashLogo.widthAnchor.constraint(equalToConstant: 80),
            splashLogo.heightAnchor.constraint(equalToConstant: 80),
            
            splashText.topAnchor.constraint(equalTo: splashLogo.bottomAnchor, constant: 20),
            splashText.centerXAnchor.constraint(equalTo: splashView.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, slides.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleSkip() {
        let lastIndex = slides.count - 1
        let indexPath = IndexPath(item: lastIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Animations
    private func animateSplash() {
        // Pulse animation
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.splashLogo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.splashLogo.layer.shadowColor = UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0).cgColor
            self.splashLogo.layer.shadowOpacity = 0.8
            self.splashLogo.layer.shadowRadius = 20
        }, completion: nil)
        
        // Text fade in
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
            self.splashText.alpha = 1
            self.splashText.transform = .identity
        }, completion: { _ in
            // Dismiss splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.splashView.alpha = 0
                }) { _ in
                    self.splashView.isHidden = true
                    self.splashLogo.layer.removeAllAnimations()
                }
            }
        })
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == slides.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
            cell.configure(with: slides[indexPath.item])
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let currentPage = Int(round(x / width))
        
        if pageControl.currentPage != currentPage {
            pageControl.currentPage = currentPage
            // Haptic feedback could go here
        }
        
        // Background Transition Logic
        // Calculate relative progress between pages (0.0 to 3.0)
        let progress = x / width
        
        // We have 4 backgrounds for 4 pages.
        // Page 0 -> BG 0 alpha 1
        // Page 0.5 -> BG 0 alpha 0.5, BG 1 alpha 0.5
        // Page 1 -> BG 1 alpha 1
        
        for (index, bgView) in backgroundViews.enumerated() {
            // Calculate distance from current scroll position to this page's center
            let distance = abs(progress - CGFloat(index))
            
            if distance < 1.0 {
                bgView.alpha = 1.0 - distance
            } else {
                bgView.alpha = 0
            }
        }
    }
}

// MARK: - Custom Cells

class OnboardingCell: UICollectionViewCell {
    
    private let iconContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        v.layer.cornerRadius = 20
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .lightGray
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150), // Space for controls
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            iconContainer.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -30),
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            iconContainer.widthAnchor.constraint(equalToConstant: 64),
            iconContainer.heightAnchor.constraint(equalToConstant: 64),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with data: SlideData) {
        titleLabel.text = data.title
        descLabel.text = data.description
        iconImageView.image = UIImage(systemName: data.iconName)
        iconImageView.tintColor = data.color
        
        // Add glow effect based on color
        iconContainer.layer.shadowColor = data.color.cgColor
        iconContainer.layer.shadowOpacity = 0.5
        iconContainer.layer.shadowRadius = 20
    }
}

class SubscriptionCell: UICollectionViewCell {
    
    private let badgeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "METRO X PRO"
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(red: 112/255, green: 0/255, blue: 255/255, alpha: 1.0)
        lbl.layer.cornerRadius = 12
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Upgrade Your\nJourney"
        lbl.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let cardView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let v = UIVisualEffectView(effect: blurEffect)
        v.layer.cornerRadius = 24
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        let attrString = NSMutableAttributedString(string: "$4.99", attributes: [
            .font: UIFont.systemFont(ofSize: 32, weight: .bold),
            .foregroundColor: UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
        ])
        attrString.append(NSAttributedString(string: "/mo", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.lightGray
        ]))
        lbl.attributedText = attrString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let planNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Annual Pass"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let featuresStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let ctaButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start 7-Day Free Trial", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let termsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cancel anytime. Terms apply."
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(badgeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(cardView)
        
        // Card Content
        cardView.contentView.addSubview(planNameLabel)
        cardView.contentView.addSubview(priceLabel)
        cardView.contentView.addSubview(featuresStack)
        cardView.contentView.addSubview(ctaButton)
        cardView.contentView.addSubview(termsLabel)
        
        let features = ["Ad-free experience", "Offline 3D Maps", "Priority Support", "Family Sharing (up to 5)"]
        for feature in features {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            
            let icon = UIImageView(image: UIImage(systemName: "checkmark"))
            icon.tintColor = UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
            icon.contentMode = .scaleAspectFit
            icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            let lbl = UILabel()
            lbl.text = feature
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 16)
            
            row.addArrangedSubview(icon)
            row.addArrangedSubview(lbl)
            featuresStack.addArrangedSubview(row)
        }
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 50),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            cardView.heightAnchor.constraint(equalToConstant: 380),
            
            titleLabel.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            badgeLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            badgeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            badgeLabel.widthAnchor.constraint(equalToConstant: 120),
            badgeLabel.heightAnchor.constraint(equalToConstant: 28),
            
            // Inside Card
            planNameLabel.topAnchor.constraint(equalTo: cardView.contentView.topAnchor, constant: 24),
            planNameLabel.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 24),
            
            priceLabel.centerYAnchor.constraint(equalTo: planNameLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -24),
            
            featuresStack.topAnchor.constraint(equalTo: planNameLabel.bottomAnchor, constant: 30),
            featuresStack.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 24),
            featuresStack.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -24),
            
            ctaButton.bottomAnchor.constraint(equalTo: termsLabel.topAnchor, constant: -12),
            ctaButton.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 24),
            ctaButton.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -24),
            ctaButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsLabel.bottomAnchor.constraint(equalTo: cardView.contentView.bottomAnchor, constant: -20),
            termsLabel.centerXAnchor.constraint(equalTo: cardView.contentView.centerXAnchor)
        ])
    }
}
