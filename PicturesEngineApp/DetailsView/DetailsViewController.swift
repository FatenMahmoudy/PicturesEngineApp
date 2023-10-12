//
//  DetailsViewController.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 11/10/2023.
//

import Foundation
import UIKit
import Kingfisher
import Combine

final class DeatilsViewController: UIViewController {
  
  // MARK: - Properties
  
  private let viewModel: DetailsViewModel
  private var cancellables: Set<AnyCancellable> = []
  
  private var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.layer.cornerRadius = 20
    view.layer.masksToBounds = false
    view.layer.shadowOpacity = 0.24
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 2
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let imageView: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(systemName: "hourglass")
    img.tintColor = .lightGray
    img.backgroundColor = .clear
    img.contentMode = .scaleAspectFill
    img.layer.cornerRadius = 20
    img.clipsToBounds = true
    img.translatesAutoresizingMaskIntoConstraints = false
    return img
  }()
  
  // MARK: - Init
  
  init(viewModel: DetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationView()
    setupView()
    setupLayouts()
    bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.downloadUIImages()
  }
  
  // MARK: - Private
  
  private func bindViewModel() {
    self.viewModel.$images
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        animateImages()
      }
      .store(in: &self.cancellables)

  }
  
  private func setupNavigationView() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = .darkText
    navigationItem.title = "Photos"
  }
  
  private func setupView() {
    view.backgroundColor = .backgroundColor
    view.addSubview(containerView)
    containerView.addSubview(imageView)
  }
  
  private func setupLayouts() {
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -40),
    ])
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
  
  private func animateImages() {
    
    var timerCurrentCount = 0
    let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
      guard let self else { return }

      DispatchQueue.main.async {

        if timerCurrentCount == self.viewModel.images.count {
          timer.invalidate()
        } else {
          UIView.transition(with: self.imageView,
                            duration: 1,
                            options: .transitionCrossDissolve,
                            animations: {
            self.imageView.image = self.viewModel.images[timerCurrentCount]

          }) { _ in
            timerCurrentCount += 1
          }

        }
      }

    }
  }
}
