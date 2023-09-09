//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 09/09/23.
//

import UIKit

enum RMSettingsOption: CaseIterable {
  case rateApp
  case contactUs
  case terms
  case privacy
  case apiReference
  case viewSeries
  case viewCode
  
  var displayedTitle: String {
    switch self {
      case .rateApp:
        return "Rate App"
      case .contactUs:
        return "Contact Us"
      case .terms:
        return "Terms of Service"
      case .privacy:
        return "Privacy"
      case .apiReference:
        return "API Reference"
      case .viewSeries:
        return "View Video Series"
      case .viewCode:
        return "View App Code"
    }
  }
  
  var iconImage: UIImage? {
    switch self {
      case .rateApp:
        return UIImage(systemName: "star.fill")
      case .contactUs:
        return UIImage(systemName: "paperplane")
      case .terms:
        return UIImage(systemName: "doc")
      case .privacy:
        return UIImage(systemName: "lock")
      case .apiReference:
        return UIImage(systemName: "list.clipboard")
      case .viewSeries:
        return UIImage(systemName: "tv.fill")
      case .viewCode:
        return UIImage(systemName: "hammer.fill")
    }
  }
  
  var iconContainerColor: UIColor {
    switch self {
      case .rateApp:
        return .systemBlue
      case .contactUs:
          return .systemGreen
      case .terms:
        return .systemRed
      case .privacy:
        return .systemYellow
      case .apiReference:
        return .systemOrange
      case .viewSeries:
        return .systemPurple
      case .viewCode:
        return .systemPink
    }
  }
}
