//
//  RMCharacterInfoCellViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 02/09/23.
//

import UIKit

final class RMCharacterInfoCellViewModel {
  private let type: `Type`
  
  /// Value of the current cell
  private let value: String
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
    formatter.timeZone = .current
    return formatter
  }()
  
  static let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.timeZone = .current
    return formatter
  }()
  
  /// Title of the current cell
  public var title: String {
    self.type.displayTitle
  }
  
  /// Computed property that manages the display value for the current cell
  public var displayValue: String {
    if value.isEmpty {
      return "None"
    }
    
    if type == .created {
      guard let date = Self.dateFormatter.date(from: value) else {
        return "None"
      }
      return Self.shortDateFormatter.string(from: date)
    }
    
    return value
  }
  
  /// Computed property that manages the icon image for the current cell
  public var iconImage: UIImage? {
    return type.iconImage
  }
  
  /// Computed property that manages the tint color for the current cell
  public var tintColor: UIColor {
    return type.tintColor
  }
  
  enum `Type`: String {
    case status
    case gender
    case type
    case species
    case origin
    case created
    case location
    case episodeCount
    
    var iconImage: UIImage? {
      switch self {
        case .status:
          return UIImage(systemName: "bell")
        case .gender:
          return UIImage(systemName: "bell")
        case .type:
          return UIImage(systemName: "bell")
        case .species:
          return UIImage(systemName: "bell")
        case .origin:
          return UIImage(systemName: "bell")
        case .created:
          return UIImage(systemName: "bell")
        case .location:
          return UIImage(systemName: "bell")
        case .episodeCount:
          return UIImage(systemName: "bell")
      }
    }
    
    var displayTitle: String {
      switch self {
        case .status:
          return rawValue.uppercased()
        case .gender:
          return rawValue.uppercased()
        case .type:
          return rawValue.uppercased()
        case .species:
          return rawValue.uppercased()
        case .origin:
          return rawValue.uppercased()
        case .created:
          return rawValue.uppercased()
        case .location:
          return rawValue.uppercased()
        case .episodeCount:
          return "EPISODE COUNT"
      }
    }
    
    var tintColor: UIColor {
      switch self {
        case .status:
          return .systemBlue
        case .gender:
          return .systemRed
        case .type:
          return .systemPurple
        case .species:
          return .systemGreen
        case .origin:
          return .systemOrange
        case .created:
          return .systemPink
        case .location:
          return .systemYellow
        case .episodeCount:
          return .systemMint
      }
    }
  }
  
  init(type: `Type`, value: String) {
    self.type = type
    self.value = value
  }
}
