//
//  DeveloperViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//



// Uzun vadeli güncelleme --> Fotoğrafların boyutu büyük, geri bildirim gönderirikenki yüklenen fotoğrafların boyutu küçültülecek. --- Done

// Güncelleme --> Fotoğraf indirme ve feedback arrayine ekleme senkronu düzeltilecek.




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
        getUnansweredQuestionsData()
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
            performSegue(withIdentifier: "developerToQuestionAnswer", sender: nil)
        }
        if index == 5 {
            performSegue(withIdentifier: "developerToFeedBacks", sender: nil)
        }
    }
    
    //Feedbacks için verileri çekme
    private func fetchData() {
        var userArray = [""]
        userArray = []
        db.collection("Feedbacks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    userArray.append("\(document.documentID)")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var newFeedbacks = [Feedback]()
            for user in userArray {
                print("pp\(user)")
                self.db.collection("Feedbacks").document(user).collection("Timestamp").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        for timestamp in querySnapshot!.documents {
                            print("iii\(timestamp.documentID)")
                            self.db.collection("Feedbacks").document(user).collection("\(timestamp.documentID)").document("Feedback").getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let dataDocument = document.data()
                                    
                                    var feedBackImage = UIImage(data: Data())
                                    let storageRef = self.storage.reference()
                                    let imagesRef = storageRef.child("Feedbacks")
                                    let images1Ref = imagesRef.child("\(user)")
                                    let images2Ref = images1Ref.child("\(timestamp.documentID)")
                                    print("şşş\(user)---\(timestamp.documentID)")
                                    images2Ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                        if let error = error {
                                            print("Eror :\(error)")
                                            feedBackImage = nil
                                            if let timeStamp = Double("\(timestamp.documentID)") {
                                                let text = dataDocument!["\(timestamp.documentID)"] as! String
                                                let exampleFeedback = Feedback(userEmail: "\(user)", timestamp: Date(timeIntervalSince1970: timeStamp), text: text, imageData: UIImage(named: "logo")!)
                                                newFeedbacks.append(exampleFeedback)
                                            }
                                        }else {
                                            let image = UIImage(data: data!)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                feedBackImage = image
                                                if let timeStamp = Double("\(timestamp.documentID)") {
                                                    let text = dataDocument!["\(timestamp.documentID)"] as! String
                                                    let exampleFeedback = Feedback(userEmail: "\(user)", timestamp: Date(timeIntervalSince1970: timeStamp), text: text, imageData: feedBackImage!)
                                                    newFeedbacks.append(exampleFeedback)
                                                    feedBackImage = UIImage(data: Data())
                                                }
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
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                print("Eklendi")
                feedbacks += newFeedbacks
            }
        }
    }
    func getUnansweredQuestionsData(){
        self.db.collection("developer@gmail.com").document("Products").collection("unansweredQuestions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let productName = data["name"] as! String
                    let category = document.documentID
                    self.db.collection("developer@gmail.com").document("Products").collection("unansweredQuestions").document(category).collection(productName).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                let senderName = document.documentID
                                let productname = data["name"] as! String
                                let model = QuestionProductModel(category: category, productName: productName, senderName: senderName, Product: productname)
                                unansweredProductsInfo.append(model)
                            }
                        }
                    }
                }
            }
        }
    }
}

