//
//  AJMetroXLaunchViewController.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

class AJMetroXLaunchViewController: UIViewController {
    
    // MARK: - Properties
    private let configuration: AJLaunchScreenConfiguration
    private var slides: [AJSlideData] = []
    private var backgroundViews: [UIImageView] = []
    private let backgroundImages = ["bg_speed", "bg_nodes", "bg_speed", "bg_glass"]
    
    // MARK: - UI Components
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
        cv.register(AJMetroXOnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        cv.register(AJMetroXSubscriptionCell.self, forCellWithReuseIdentifier: "SubscriptionCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = slides.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = configuration.primaryColor ?? UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
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
        btn.setTitle(NSLocalizedString("Skip", comment: ""), for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        btn.isHidden = !configuration.showSkipButton
        return btn
    }()
    
    private lazy var splashView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var splashLogo: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let color = configuration.primaryColor ?? UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
        view.layer.borderColor = color.cgColor
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
        let color = configuration.primaryColor ?? UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
        attrString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 6, length: 1))
        lbl.attributedText = attrString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.alpha = 0
        return lbl
    }()
    
    // MARK: - Initialization
    init(configuration: AJLaunchScreenConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        setupSlides()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    private func setupSlides() {
        if let customSlides = configuration.customSlides {
            slides = customSlides
        } else {
            let primaryColor = configuration.primaryColor ?? UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
            slides = [
                AJSlideData(
                    title: NSLocalizedString("Real-Time\nPrecision", comment: ""),
                    description: NSLocalizedString("Live tracking of every train in the network. Know exactly when to arrive, down to the second.", comment: ""),
                    iconName: "location.circle.fill",
                    color: primaryColor
                ),
                AJSlideData(
                    title: NSLocalizedString("Smart\nNavigation", comment: ""),
                    description: NSLocalizedString("AR-powered guidance through complex interchanges. Never get lost in the underground again.", comment: ""),
                    iconName: "map.fill",
                    color: UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1.0)
                ),
                AJSlideData(
                    title: NSLocalizedString("Seamless\nAccess", comment: ""),
                    description: NSLocalizedString("Tap to pay with NFC. Integrated digital tickets for all major transit lines worldwide.", comment: ""),
                    iconName: "wave.3.right.circle.fill",
                    color: UIColor(red: 0/255, green: 255/255, blue: 170/255, alpha: 1.0)
                ),
                AJSlideData(
                    title: NSLocalizedString("Upgrade Your\nJourney", comment: ""),
                    description: "",
                    iconName: "star.fill",
                    color: .white
                )
            ]
        }
    }
    
    private func setupBackgrounds() {
        view.backgroundColor = .black
        
        let bundle = Bundle(for: type(of: self))
        for (index, imageName) in backgroundImages.enumerated() {
            let iv = UIImageView()
            if let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) {
                iv.image = image
            }
            iv.contentMode = .scaleAspectFill
            iv.frame = view.bounds
            iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            iv.alpha = index == 0 ? 1 : 0
            view.insertSubview(iv, at: index)
            backgroundViews.append(iv)
            
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [
                UIColor.black.withAlphaComponent(0.1).cgColor,
                UIColor.black.withAlphaComponent(0.8).cgColor
            ]
            gradient.locations = [0.0, 1.0]
            iv.layer.addSublayer(gradient)
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
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
        configuration.delegate?.launchScreenDidSkip()
        AJLaunchScreenManager.shared.dismiss()
    }
    
    private func handleComplete() {
        configuration.delegate?.launchScreenDidComplete()
        AJLaunchScreenManager.shared.dismiss()
    }
    
    private func handleSubscribe() {
        configuration.delegate?.launchScreenDidSelectSubscription()
    }
    
    // MARK: - Animations
    private func animateSplash() {
        let color = configuration.primaryColor ?? UIColor(red: 0/255, green: 242/255, blue: 255/255, alpha: 1.0)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.splashLogo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.splashLogo.layer.shadowColor = color.cgColor
            self.splashLogo.layer.shadowOpacity = 0.8
            self.splashLogo.layer.shadowRadius = 20
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: {
            self.splashText.alpha = 1
            self.splashText.transform = .identity
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: self.configuration.animationDuration, animations: {
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
extension AJMetroXLaunchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == slides.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! AJMetroXSubscriptionCell
            cell.onSubscribeAction = { [weak self] in
                self?.handleSubscribe()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! AJMetroXOnboardingCell
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
        }
        
        let progress = x / width
        
        for (index, bgView) in backgroundViews.enumerated() {
            let distance = abs(progress - CGFloat(index))
            
            if distance < 1.0 {
                bgView.alpha = 1.0 - distance
            } else {
                bgView.alpha = 0
            }
        }
    }
}
