//
//  SearchViewController.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation
import UIKit
import Combine

final class SearchViewController: UIViewController {
  
  private let viewModel: SearchViewModel
  private var cancellables: Set<AnyCancellable> = []
  
  private var searchController: UISearchController?
  
  private lazy var dataSource = self.makeDataSource()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 16
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.register(SearchCollectionViewCell.self,
                            forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private var button: UIButton = {
    let btn = UIButton()
    btn.isHidden = true
    btn.setTitle("Valider", for: .normal)
    btn.backgroundColor = .blue
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  private func bindViewModel() {
    self.viewModel.$photosVM
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        self.updateSnapshot()
      }
      .store(in: &self.cancellables)
    
    self.viewModel.$isValidateButtonEnabled
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        guard let self else { return }
        button.isHidden = !value
      }
      .store(in: &self.cancellables)
  }
  
  private func setup() {
    self.view.backgroundColor = .backgroundColor
    self.setupSearchNavigationBar()
    self.setupCollectionView()
    self.setupLayout()
    self.bindViewModel()
  }
  
  private func setupSearchNavigationBar() {
    self.searchController = UISearchController()
    self.searchController?.hidesNavigationBarDuringPresentation = false
    self.searchController?.obscuresBackgroundDuringPresentation = false
    self.searchController?.searchBar.placeholder = "Chercher une image"
    self.searchController?.searchBar.accessibilityIdentifier = "SearchBar"
    
    self.searchController?.searchBar.delegate = self
    self.definesPresentationContext = true
    self.navigationItem.searchController = self.searchController
  }
  
  private func setupCollectionView() {
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.button)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self.dataSource
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
    ])
    
    NSLayoutConstraint.activate([
      self.button.heightAnchor.constraint(equalToConstant: 40),
      self.button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      self.button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchController?.searchBar.text {
      Task {
        try await self.viewModel.getPhotosSearch(query: searchText)
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.searchController?.searchResultsController?.dismiss(animated: false)
  }
}

extension SearchViewController: UICollectionViewDelegate {
  private enum Section {
    case main
  }
  
  private class DataSource: UICollectionViewDiffableDataSource<Section, SearchCollectionCellViewModel> {}
  
  private func makeDataSource() -> DataSource {
    
    return DataSource(
      collectionView: self.collectionView,
      cellProvider: { collectionView, indexPath, searchCollectionCellViewModel in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else {
          assertionFailure("Failed to dequeue \(SearchCollectionViewCell.self)")
          return UICollectionViewCell()
        }
        cell.configure(with: searchCollectionCellViewModel)
        return cell
      }
    )
  }
  
  private func updateSnapshot(animate: Bool = false) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, SearchCollectionCellViewModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(self.viewModel.photosVM, toSection: .main)
    self.dataSource.apply(snapshot, animatingDifferences: animate)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      Task {
        try await self.viewModel.getNextPhotosSearch()
      }
      
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
    item.didTapOnCell()
    viewModel.updateSelectedPhotos(photo: item.photo)
  }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(width: (view.frame.width / 2) - 8 , height: (view.frame.width / 2) - 8 )
  }
}
