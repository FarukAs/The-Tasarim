//
//  AnswerQuestionViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 3.05.2023.
//

import UIKit

class AnswerQuestionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var selectedProduct = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadUnansweredQuestions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.tableView.reloadData()
        }
        
    }
    func loadUnansweredQuestions() {
        print("sess",unansweredQuestions)
        let questions = unansweredQuestions.filter { $0.productName == selectedProduct }
        print("ses",questions)
        unansweredQuestions = questions
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.register(AnswerQuestionTableViewCell.self, forCellReuseIdentifier: "AnswerQuestionTableViewCell")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unansweredQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerQuestionTableViewCell", for: indexPath) as! AnswerQuestionTableViewCell
        let question = unansweredQuestions[indexPath.row]
        cell.configure(with: question)
        cell.parentViewController = self
        return cell
    }
}
