//
//  SearchViewController.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController {
  
  private let viewModel: SearchViewModel
  private var searchController: UISearchController?
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 16
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.register(HomeCollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
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
  
  private func setup() {
    self.view.backgroundColor = .backgroundColor
    self.setupSearchNavigationBar()
//    self.setupCollectionView()
//    self.setupLayout()
//    self.viewModel.autocompleteViewModel.configure(delegate: self)
  }
  
  private func setupSearchNavigationBar() {
    self.searchController = UISearchController()
    self.searchController?.hidesNavigationBarDuringPresentation = false
    self.searchController?.obscuresBackgroundDuringPresentation = false
    self.searchController?.searchBar.placeholder = "Chercher une image"
    self.searchController?.searchBar.accessibilityIdentifier = "SearchBar"
    
//    self.searchController?.searchResultsUpdater = self
    self.searchController?.searchBar.delegate = self
    self.definesPresentationContext = true
    self.navigationItem.searchController = self.searchController
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchText = searchController?.searchBar.text {
      print(searchText)
//      self.viewModel.handle(action: .launchGetTeamsListRequest(leagueName: searchText))
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.searchController?.searchResultsController?.dismiss(animated: false)
  }
}
