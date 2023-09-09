//
//  RMSettingCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 09/09/23.
//

import UIKit

struct RMSettingCellViewViewModel: Identifiable, Hashable {
  let id = UUID()
  
  private let type: RMSettingsOption
  
  public var image: UIImage? {
    return type.iconImage
  }
  
  public var title: String {
    return type.displayedTitle
  }
  
  public var iconContainerColor: UIColor {
    return type.iconContainerColor
  }
  
  init(type: RMSettingsOption) {
    self.type = type
  }
}
