//
//  AJBalloonAnimationView.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

class AJBalloonAnimationView: UIView {
    
    private let balloonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(balloonImageView)
        
        // Load balloon image from bundle
        let bundle = Bundle(for: type(of: self))
        if let balloonImage = UIImage(named: "balloon_orange", in: bundle, compatibleWith: nil) {
            balloonImageView.image = balloonImage
        } else {
            // Fallback: create programmatic balloon
            balloonImageView.image = createBalloonImage()
        }
        
        NSLayoutConstraint.activate([
            balloonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            balloonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            balloonImageView.widthAnchor.constraint(equalToConstant: 180),
            balloonImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func startAnimations() {
        // Floating animation
        let floatAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        floatAnimation.values = [0, -15, 0, 15, 0]
        floatAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        floatAnimation.duration = 4.0
        floatAnimation.repeatCount = .infinity
        floatAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Subtle rotation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [0, 0.05, 0, -0.05, 0]
        rotateAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        rotateAnimation.duration = 5.0
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        balloonImageView.layer.add(floatAnimation, forKey: "floating")
        balloonImageView.layer.add(rotateAnimation, forKey: "rotation")
    }
    
    private func createBalloonImage() -> UIImage {
        let size = CGSize(width: 180, height: 220)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let ctx = context.cgContext
            
            // Draw balloon circle
            let balloonRect = CGRect(x: 30, y: 20, width: 120, height: 120)
            ctx.setFillColor(UIColor(red: 255/255, green: 159/255, blue: 64/255, alpha: 1.0).cgColor)
            ctx.fillEllipse(in: balloonRect)
            
            // Draw face - closed eyes
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.setLineWidth(3)
            ctx.setLineCap(.round)
            
            // Left eye
            ctx.move(to: CGPoint(x: 65, y: 65))
            ctx.addLine(to: CGPoint(x: 75, y: 65))
            ctx.strokePath()
            
            // Right eye
            ctx.move(to: CGPoint(x: 105, y: 65))
            ctx.addLine(to: CGPoint(x: 115, y: 65))
            ctx.strokePath()
            
            // Smile
            let smilePath = UIBezierPath()
            smilePath.move(to: CGPoint(x: 70, y: 85))
            smilePath.addQuadCurve(to: CGPoint(x: 110, y: 85), controlPoint: CGPoint(x: 90, y: 100))
            smilePath.lineWidth = 3
            UIColor.black.setStroke()
            smilePath.stroke()
            
            // Draw string
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2)
            
            let stringPath = UIBezierPath()
            stringPath.move(to: CGPoint(x: 90, y: 140))
            stringPath.addCurve(
                to: CGPoint(x: 95, y: 200),
                controlPoint1: CGPoint(x: 85, y: 160),
                controlPoint2: CGPoint(x: 100, y: 180)
            )
            stringPath.lineWidth = 2
            UIColor.white.setStroke()
            stringPath.stroke()
        }
    }
}
