//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 14/09/23.
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
  static let cellIdentifier = "RMLocationTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  public func configure(with: RMLocationTableViewCellViewModel) { }
}
