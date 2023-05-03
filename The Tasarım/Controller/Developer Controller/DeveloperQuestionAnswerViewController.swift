//
//  DeveloperQuestionAnswerViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Dispatch
class DeveloperQuestionAnswerViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let db = Firestore.firestore()
    var unansweredProduct = [productBrain]()
    override func viewDidLoad() {
        super.viewDidLoad()
        unansweredQuestions = []
        unansweredProduct = []
        getUnansweredQuestionsDataFromDictionary()
        tableView.register(DeveloperQuestionAnswerTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func getUnansweredQuestionsDataFromDictionary() {
        for itm in unansweredProductsInfo {
            self.db.collection("developer@gmail.com").document("Products").collection(itm.category).document(itm.productName).collection("QuestionsAnswers").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let answered = data["answered"] as? Bool
                        if let questionDate = data["questionDate"] as? Double , let askerName = data["askerName"] as? String , let question = data["question"] as? String , let title = data["title"] as? String , let answerDate = data["answerDate"] as? Double , let answer = data["answer"] as? String , let sellerName = data["sellerName"] as? String  {
                            let model = QuestionAnswerModel(question: question, askerName: askerName, questionDate: Double(questionDate), answer: answer, sellerName: sellerName, answerDate: Double(answerDate), isAnonymus: false, answered: answered!, title: title)
                            unansweredQuestions.append(model)
                            for itm1 in productArray {
                                if itm1.productName == itm.productName {
                                    unansweredProducts.append(itm1.productName)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            self.getProducts()
            self.tableView.reloadData()
        }
    }
    func getProducts(){
        for itm in unansweredProducts{
            for itm1 in productArray{
                if itm == itm1.productName {
                    unansweredProduct.append(itm1)
                }
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionAnswerData.count == 0 {
            return 0
        }else{
            return unansweredQuestions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questionAnswerData.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! DeveloperQuestionAnswerTableViewCell
            let product = unansweredProduct[indexPath.row]
            cell.configure(with: product)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! DeveloperQuestionAnswerTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for itm in unansweredProductsInfo {
            if unansweredProduct[indexPath.row].productName == itm.productName{
                let selectedProductCategory = itm.category
                let selectedProductName = itm.productName

                let question = unansweredQuestions[indexPath.row]
                let answerQuestionVC = AnswerQuestionViewController(question: question)
                answerQuestionVC.selectedProductName = selectedProductName
                answerQuestionVC.selectedProductCategory = selectedProductCategory
                
                navigationController?.pushViewController(answerQuestionVC, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
