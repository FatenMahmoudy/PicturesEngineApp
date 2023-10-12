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
  
  // MARK: - Properties
  
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
  
  private let button: UIButton = {
    let btn = UIButton()
    btn.isHidden = true
    btn.setTitle("Valider", for: .normal)
    btn.backgroundColor = .buttonColor
    btn.layer.cornerRadius = 20
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
  
  // MARK: - Init
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Private
  
  private func bindViewModel() {
    self.viewModel.$photosVM
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else { return }
        updateSnapshot()
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
    view.backgroundColor = .backgroundColor
    setupSearchNavigationBar()
    setupViews()
    setupLayout()
    bindViewModel()
  }
  
  private func setupSearchNavigationBar() {
    searchController = UISearchController()
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.obscuresBackgroundDuringPresentation = false
    searchController?.searchBar.placeholder = "Chercher une image"
    searchController?.searchBar.accessibilityIdentifier = "SearchBar"
    
    searchController?.searchBar.delegate = self
    self.definesPresentationContext = true
    navigationItem.searchController = searchController
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = .darkText
    navigationItem.title = "Search"
  }
  
  private func setupViews() {
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self.dataSource
    
    view.addSubview(button)
    button.addTarget(self, action: #selector(didTapOnValidateButton), for: .touchUpInside)
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 40),
      button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
    ])
  }
  
  @objc
  func didTapOnValidateButton() {
    navigationController?.pushViewController(DeatilsViewController(viewModel: DetailsViewModel(photos: viewModel.selectedPhotos)), animated: true)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchController?.searchBar.text, searchText != "" {
      Task {
        try await viewModel.getPhotosSearch(query: searchText)
      }
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.removeLastSearchList()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.removeLastSearchList()
  }
}

extension SearchViewController: UICollectionViewDelegate {
  private enum Section {
    case main
  }
  
  private class DataSource: UICollectionViewDiffableDataSource<Section, SearchCollectionCellViewModel> {}
  
  private func makeDataSource() -> DataSource {
    
    return DataSource(
      collectionView: collectionView,
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
    snapshot.appendItems(viewModel.photosVM, toSection: .main)
    self.dataSource.apply(snapshot, animatingDifferences: animate)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      Task {
        try await viewModel.getNextPhotosSearch()
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
