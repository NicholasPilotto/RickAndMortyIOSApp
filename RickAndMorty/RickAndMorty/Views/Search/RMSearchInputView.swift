//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Nicholas Pilotto on 17/09/23.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
  func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
}

final class RMSearchInputView: UIView {
  private let searchBar: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "Search"
    bar.translatesAutoresizingMaskIntoConstraints = false
    return bar
  }()
  
  private var viewModel: RMSearchInputViewViewModel? {
    didSet {
      guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
        return
      }
      
      let options = viewModel.options
      createOptionsSelectionView(options: options)
    }
  }
  
  weak public var delegate: RMSearchInputViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(searchBar)
    
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 3),
      searchBar.leftAnchor.constraint(equalTo: leftAnchor),
      searchBar.rightAnchor.constraint(equalTo: rightAnchor),
      searchBar.heightAnchor.constraint(equalToConstant: 55)
    ])
  }
  
  private func createOptionsSelectionView(options: [RMSearchInputViewViewModel.DynamicOptions]) {
    let stackView = createOptionStackView()
    
    for i in 0..<options.count {
      let option = options[i]
      let button = createButton(with: option, tag: i)
      
      stackView.addArrangedSubview(button)
    }
  }
  
  @objc private func didTapButton(_ sender: UIButton) {
    guard let options = viewModel?.options else {
      return
    }
    
    let tag = sender.tag
    let selected = options[tag]
    
    delegate?.rmSearchInputView(self, didSelectOption: selected)
  }
  
  private func createOptionStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 6
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    return stackView
  }
  
  private func createButton(with option: RMSearchInputViewViewModel.DynamicOptions, tag: Int) -> UIButton {
    let button = UIButton()
    button.backgroundColor = .secondarySystemFill
    button.setAttributedTitle(
      NSAttributedString(string: option.rawValue, attributes: [
        .font: UIFont.systemFont(ofSize: 18, weight: .medium),
        .foregroundColor: UIColor.label
      ]),
      for: .normal
    )
    
    button.tag = tag
    button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    button.layer.cornerRadius = 8
    button.layer.cornerCurve = CALayerCornerCurve.continuous
    
    return button
  }
  
  /// Configure view with view model
  /// - Parameter viewModel: view model that manages view
  public func configure(with viewModel: RMSearchInputViewViewModel) {
    searchBar.placeholder = viewModel.searchPlaceholderText
    self.viewModel = viewModel
  }
  
  /// Show keyboard
  public func presentKeyboard() {
    searchBar.becomeFirstResponder()
  }
}
