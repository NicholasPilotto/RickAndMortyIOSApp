//
//  RMSettingCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 09/09/23.
//

import UIKit

struct RMSettingCellViewViewModel: Identifiable {
  let id = UUID()

  public let type: RMSettingsOption

  public var image: UIImage? {
    return type.iconImage
  }

  public var title: String {
    return type.displayedTitle
  }

  public var iconContainerColor: UIColor {
    return type.iconContainerColor
  }

  public let onTapHandler: (RMSettingsOption) -> Void

  init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
    self.type = type
    self.onTapHandler = onTapHandler
  }
}
