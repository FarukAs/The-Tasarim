//
//  FavoritesViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 29.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class FavoritesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, FavoritesTableViewCellDelegate {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let user = Auth.auth().currentUser?.email
    var searchBar = UISearchBar()
    var tableView = UITableView()
    var filteredProducts: [productBrain] = []
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredProducts = userFavorites
        } else {
            isSearching = true
            filteredProducts = userFavorites.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredProducts.count
        } else {
            return userFavorites.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! FavoritesTableViewCell
        let array: productBrain
        if isSearching {
            array = filteredProducts[indexPath.row]
        } else {
            array = userFavorites[indexPath.row]
        }
        
        // Assign the delegate and indexPath properties
        cell.delegate = self
        cell.indexPath = indexPath
        cell.addToCartButton.indexPath = indexPath
        cell.configure(with: array)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    func addToCartButtonPressed(at indexPath: IndexPath) {
        print("Add to cart button pressed at row: \(indexPath.row)")
        print("Burada sepete ekleme işlemi yapılacak fakat seçilen satır searchbarda arama yapıldığında değişiyor , arrayin içinden seçilen ürün karıştırılabilir")
    }
    
}
