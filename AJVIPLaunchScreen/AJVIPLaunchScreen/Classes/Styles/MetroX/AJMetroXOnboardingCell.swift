//
//  AJMetroXOnboardingCell.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

class AJMetroXOnboardingCell: UICollectionViewCell {
    
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
            descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
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
    
    func configure(with data: AJSlideData) {
        titleLabel.text = data.title
        descLabel.text = data.description
        iconImageView.image = UIImage(systemName: data.iconName)
        iconImageView.tintColor = data.color
        
        iconContainer.layer.shadowColor = data.color.cgColor
        iconContainer.layer.shadowOpacity = 0.5
        iconContainer.layer.shadowRadius = 20
    }
}
