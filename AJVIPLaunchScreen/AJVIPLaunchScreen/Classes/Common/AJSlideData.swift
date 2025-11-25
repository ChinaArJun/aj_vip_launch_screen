//
//  AJSlideData.swift
//  AJVIPLaunchScreen
//
//  Created by AJ on 2025/11/25.
//

import UIKit

/// Data model for onboarding slides
public struct AJSlideData {
    public let title: String
    public let description: String
    public let iconName: String
    public let color: UIColor
    
    public init(title: String, description: String, iconName: String, color: UIColor) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.color = color
    }
}
