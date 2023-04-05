//
//  ListedProductsViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 5.04.2023.
//


import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class ListedProductsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    
    var originalListedProducts: [String] = []
    var originalNonListedProducts: [String] = []
    var listedProducts: [String] = []
    var nonListedProducts: [String] = []
    var selectedIndexPath: IndexPath?
    
    // Yeşil oklu buton
    let upArrowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        button.setTitle("↑", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    
    // Kırmızı oklu buton
    let downArrowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        button.setTitle("↓", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    // Listed Products Label
    let listedProductsLabel: UILabel = {
        let label = UILabel()
        label.text = "Listelenen Ürünler"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    // Üst table view
    let upperTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Non-Listed Products Label
    let nonListedProductsLabel: UILabel = {
        let label = UILabel()
        label.text = "Listelenmeyen Ürünler"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Alt table view
    let lowerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchData()
        setupTableViewDataSource()
        searchBar.delegate = self
        
        // Buton işlevleri
        upArrowButton.addTarget(self, action: #selector(upArrowButtonTapped), for: .touchUpInside)
        downArrowButton.addTarget(self, action: #selector(downArrowButtonTapped), for: .touchUpInside)
    }
    
    func setupViews() {
        view.addSubview(upArrowButton)
        view.addSubview(downArrowButton)
        view.addSubview(listedProductsLabel)
        view.addSubview(searchBar)
        view.addSubview(upperTableView)
        view.addSubview(nonListedProductsLabel)
        view.addSubview(lowerTableView)
    }
    
    func setupConstraints() {
        // Listed Products Label
        NSLayoutConstraint.activate([
            listedProductsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            listedProductsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: listedProductsLabel.trailingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40) // ekleyin
        ])
        // Non-Listed Products Label
        
        
        // Upper Table View
        NSLayoutConstraint.activate([
            upperTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10), // güncelle
            upperTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperTableView.bottomAnchor.constraint(equalTo: upArrowButton.topAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            nonListedProductsLabel.topAnchor.constraint(equalTo: upArrowButton.bottomAnchor, constant: 20),
            nonListedProductsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        // Lower Table View
        NSLayoutConstraint.activate([
            lowerTableView.topAnchor.constraint(equalTo: nonListedProductsLabel.bottomAnchor, constant: 10),
            lowerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Up Arrow Button
        NSLayoutConstraint.activate([
            upArrowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            upArrowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            upArrowButton.widthAnchor.constraint(equalToConstant: 50),
            upArrowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Down Arrow Button
        NSLayoutConstraint.activate([
            downArrowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            downArrowButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            downArrowButton.widthAnchor.constraint(equalToConstant: 50),
            downArrowButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func fetchData() {
        db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("ListedProducts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let productId = document.documentID
                    self.originalListedProducts.append(productId) // Update original array
                    self.listedProducts.append(productId)
                }
                self.upperTableView.reloadData()
            }
        }
        
        db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("NonListedProducts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let productId = document.documentID
                    self.originalNonListedProducts.append(productId) // Update original array
                    self.nonListedProducts.append(productId)
                }
                self.lowerTableView.reloadData()
            }
        }
    }
    func setupTableViewDataSource() {
        upperTableView.dataSource = self
        upperTableView.delegate = self
        lowerTableView.dataSource = self
        lowerTableView.delegate = self
        
        upperTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        lowerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == upperTableView {
            selectedIndexPath = IndexPath(row: indexPath.row, section: 0)
        } else {
            selectedIndexPath = IndexPath(row: indexPath.row, section: 1)
        }
        
        print(selectedIndexPath)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == upperTableView {
            return listedProducts.count
        } else {
            return nonListedProducts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if tableView == upperTableView {
            cell.textLabel?.text = listedProducts[indexPath.row]
        } else {
            cell.textLabel?.text = nonListedProducts[indexPath.row]
        }
        return cell
    }
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            listedProducts = originalListedProducts
            nonListedProducts = originalNonListedProducts
        } else {
            filterProducts(searchText: searchText)
        }
        upperTableView.reloadData()
        lowerTableView.reloadData()
    }
    
    func filterProducts(searchText: String) {
        listedProducts = originalListedProducts.filter { $0.lowercased().contains(searchText.lowercased()) }
        nonListedProducts = originalNonListedProducts.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    @objc func upArrowButtonTapped() {
        if let selectedIndex = lowerTableView.indexPathForSelectedRow {
            let selectedProduct = nonListedProducts[selectedIndex.row]
            let originalIndex = originalNonListedProducts.firstIndex(of: selectedProduct)
            
            nonListedProducts.remove(at: selectedIndex.row)
            lowerTableView.deleteRows(at: [selectedIndex], with: .automatic)
            
            listedProducts.append(selectedProduct)
            originalListedProducts.append(selectedProduct)
            upperTableView.reloadData()
            
            // Firestore güncellemesi
            if let originalIndex = originalIndex {
                let documentID = originalNonListedProducts[originalIndex]
                let listedRef = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("ListedProducts").document(documentID)
                let nonListedRef = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("NonListedProducts").document(documentID)
                
                nonListedRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let data = document.data() {
                            listedRef.setData(data) { (error) in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    nonListedRef.delete()
                                    self.originalNonListedProducts.remove(at: originalIndex)
                                }
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    @objc func downArrowButtonTapped() {
        if let selectedIndex = upperTableView.indexPathForSelectedRow {
            let selectedProduct = listedProducts[selectedIndex.row]
            let originalIndex = originalListedProducts.firstIndex(of: selectedProduct)
            
            listedProducts.remove(at: selectedIndex.row)
            upperTableView.deleteRows(at: [selectedIndex], with: .automatic)
            
            nonListedProducts.append(selectedProduct)
            originalNonListedProducts.append(selectedProduct)
            lowerTableView.reloadData()
            
            // Firestore güncellemesi
            if let originalIndex = originalIndex {
                let documentID = originalListedProducts[originalIndex]
                let listedRef = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("ListedProducts").document(documentID)
                let nonListedRef = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("NonListedProducts").document(documentID)
                
                listedRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let data = document.data() {
                            nonListedRef.setData(data) { (error) in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    listedRef.delete()
                                    self.originalListedProducts.remove(at: originalIndex)
                                }
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func moveProductBetweenCollections(product: String, from sourceCollection: String, to destinationCollection: String) {
        let sourceDocument = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection(sourceCollection).document(product)
        let destinationDocument = db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection(destinationCollection).document(product)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.deleteDocument(sourceDocument)
            transaction.setData([:], forDocument: destinationDocument)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error moving product: \(error)")
            } else {
                print("Product moved successfully.")
            }
        }
    }
}

