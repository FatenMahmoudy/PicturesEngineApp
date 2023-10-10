//
//  SearchCollectionViewCell.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation
import UIKit
import Kingfisher
import Combine

final class SearchCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: SearchCollectionViewCell.self)
  
  private var viewModel: SearchCollectionCellViewModel?
  private var cancellables: Set<AnyCancellable> = []
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .backgroundColor
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let imageView: UIImageView = {
    let img = UIImageView()
    img.backgroundColor = .clear
    img.contentMode = .scaleToFill
    img.layer.cornerRadius = 10
    img.translatesAutoresizingMaskIntoConstraints = false
    return img
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isAccessibilityElement = true
    self.setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
    self.imageView.backgroundColor = .clear
  }
  
  private func bindViewModel() {
    self.viewModel?.$isSelected
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        guard let self else { return }
        self.containerView.alpha = value ? 0.7 : 1.0
      }
      .store(in: &self.cancellables)
  }
  
  func configure(with viewModel: SearchCollectionCellViewModel) {
    self.viewModel = viewModel
    self.bindViewModel()
    self.imageView.kf.setImage(with: viewModel.imageURL, placeholder: UIImage(systemName: "photo.circle.fill"))
  }
  
  private func setupUI() {
    self.backgroundColor = .backgroundColor
    
    self.containerView.addSubview(self.imageView)
    self.contentView.addSubview(self.containerView)
    
    NSLayoutConstraint.activate([
      self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
      self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
      self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
      self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
    ])
    
    NSLayoutConstraint.activate([
      self.imageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      self.imageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
      self.imageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
      self.imageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
    ])
    
  }
  
}


