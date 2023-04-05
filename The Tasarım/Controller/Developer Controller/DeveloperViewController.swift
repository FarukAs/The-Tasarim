//
//  DeveloperViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//



// Uzun vadeli güncelleme --> Fotoğrafların boyutu büyük, geri bildirim gönderirikenki yüklenen fotoğrafların boyutu küçültülecek.





import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class DeveloperViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        feedbacks = []
        fetchData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" , for: indexPath) as! TableViewCell
        cell.label.text = DeveloperMenu[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            performSegue(withIdentifier: "developerToProductEdit", sender: nil)
        }
        if index == 1 {
            performSegue(withIdentifier: "developerToListedProducts", sender: nil)
        }
        if index == 3 {
            performSegue(withIdentifier: "developerToUsers", sender: nil)
        }
        if index == 4 {
            performSegue(withIdentifier: "developerToFeedBacks", sender: nil)
        }
    }
    
    //Feedbacks için verileri çekme
    private func fetchData() {
        var idArray = ["":""]
        idArray = [:]
        db.collection("Feedbacks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    idArray["\(document.documentID)"] = "\(document.data().first!.key)"
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for itm in idArray {
                self.db.collection("Feedbacks").document("\(itm.key)").collection("\(itm.value)").getDocuments { (querySnapshot, erro) in
                    if let erro = erro {
                        print("Error getting documents: \(erro)")
                    } else {
                        print("uu\(itm.key)oo\(itm.value)")
                        var newFeedbacks = [Feedback]()
                        for documents in querySnapshot!.documents {
                            var feedBackImage = UIImage(data: Data())
                            print("pğ\(feedBackImage)")
                            let storageRef = self.storage.reference()
                            let imagesRef = storageRef.child("Feedbacks")
                            let images1Ref = imagesRef.child("\(itm.key)")
                            let images2Ref = images1Ref.child("\(itm.value)")
                            images2Ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                if let error = error {
                                    print("Eror :\(error)")
                                    feedBackImage = nil
                                    if let timestampString = documents.data().keys.first,
                                        let timestamp = Double(timestampString) {
                                       let exampleFeedback = Feedback(userEmail: "\(itm.key)", timestamp: Date(timeIntervalSince1970: timestamp), text: documents.data()[timestampString] as! String, imageData:UIImage(named: "logo")! )
                                       newFeedbacks.append(exampleFeedback)
                                   }
                                } else {
                                    // Data for "images/island.jpg" is returned
                                    let image = UIImage(data: data!)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                        feedBackImage = image
                                        if let timestampString = documents.data().keys.first,
                                           let timestamp = Double(timestampString) {
                                            let exampleFeedback = Feedback(userEmail: "\(itm.key)", timestamp: Date(timeIntervalSince1970: timestamp), text: documents.data()[timestampString] as! String, imageData: feedBackImage!)
                                            newFeedbacks.append(exampleFeedback)
                                            print("yy\(feedBackImage!)")
                                            feedBackImage = UIImage(data: Data())
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                            // Garantiye almak için 5 saniye eklendi azaltılabilir.(Fotoğrafların boyutu büyük olduğu için
                            print("Gir")
                            feedbacks += newFeedbacks
                        }
                    }
                }
            }
        }
    }
}
