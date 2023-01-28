//
//  AdressViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit

class AdressViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource {
    
    

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AdressCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdressReusableCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdressReusableCell", for: indexPath as IndexPath) as! AdressCollectionViewCell
        return cell
    }


}
