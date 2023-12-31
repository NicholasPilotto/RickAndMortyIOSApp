//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 27/08/23.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    views.forEach {
      self.addSubview($0)
    }
  }
}

extension UIDevice {
  static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}
