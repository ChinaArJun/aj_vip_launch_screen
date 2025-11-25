//
//  AJMetroXSubscriptionCell.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

class AJMetroXSubscriptionCell: UICollectionViewCell {
    
    var onSubscribeAction: (() -> Void)?
    
    private let badgeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = NSLocalizedString("METRO X PRO", comment: "")
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
        lbl.text = NSLocalizedString("Upgrade Your\nJourney", comment: "")
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
        lbl.text = NSLocalizedString("Annual Pass", comment: "")
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
    
    private lazy var ctaButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("Start 7-Day Free Trial", comment: ""), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 16
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        return btn
    }()
    
    private let termsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = NSLocalizedString("Cancel anytime. Terms apply.", comment: "")
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
        
        cardView.contentView.addSubview(planNameLabel)
        cardView.contentView.addSubview(priceLabel)
        cardView.contentView.addSubview(featuresStack)
        cardView.contentView.addSubview(ctaButton)
        cardView.contentView.addSubview(termsLabel)
        
        let features = [
            NSLocalizedString("Ad-free experience", comment: ""),
            NSLocalizedString("Offline 3D Maps", comment: ""),
            NSLocalizedString("Priority Support", comment: ""),
            NSLocalizedString("Family Sharing (up to 5)", comment: "")
        ]
        
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
    
    @objc private func handleSubscribe() {
        onSubscribeAction?()
    }
}
