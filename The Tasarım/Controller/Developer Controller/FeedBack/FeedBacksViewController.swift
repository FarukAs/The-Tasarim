//
//  FeedBacksViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 7.03.2023.
//

import UIKit
class FeedBacksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var selectedIndex = Int()
    override func viewDidLoad() {
        self.navigationItem.title = "Geri Bildirimler"
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: FeedbackTableViewCell.identifier)
        tableView.contentSize = CGSize(width: view.frame.width, height: 200)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.identifier, for: indexPath) as! FeedbackTableViewCell
        let originalFeedback = feedbacks[indexPath.row]
        let truncatedText = String(originalFeedback.text.prefix(100)) // Change 100 to your desired character limit
        
        let modifiedFeedback = Feedback(userEmail: originalFeedback.userEmail, timestamp: originalFeedback.timestamp, text: truncatedText, imageData: originalFeedback.imageData)
        
        cell.configure(with: modifiedFeedback)
        return cell
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toFeedBackDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFeedBackDetail" {
            if let destinationVC = segue.destination as? FeedBackDetailViewController {
                destinationVC.selectedIndex = selectedIndex
            }
        }
    }
}
