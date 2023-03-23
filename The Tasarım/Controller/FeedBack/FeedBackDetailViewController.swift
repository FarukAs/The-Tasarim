//
//  FeedBackDetailViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 23.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage

class FeedBackDetailViewController: UIViewController {
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var selectedIndex: Int = 0
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let feedbackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Geri Bildirim Detayları"
        
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(emailLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(feedbackImageView)
        contentView.addSubview(contentLabelContainer)
        contentLabelContainer.addSubview(contentLabel)
        
        setupConstraints()
        
        let feedback = feedbacks[selectedIndex]
        if let img0 = feedback.imageData.jpegData(compressionQuality: 1.0){
            feedbackImageView.image = UIImage(data: img0)
        }
        // Verileri elemanlara yerleştir
        emailLabel.text = "Email: \(feedback.userEmail)"
        contentLabel.text = feedback.text
        dateLabel.text = "Date: \(feedback.timestamp)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        feedbackImageView.addGestureRecognizer(tapGesture)
        let deleteButton = UIBarButtonItem(title: "Sil", style: .plain, target: self, action: #selector(deleteButtonTapped))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    @objc private func imageTapped() {
        let fullScreenImageVC = FullScreenImageViewController()
        fullScreenImageVC.image = feedbackImageView.image
        fullScreenImageVC.modalPresentationStyle = .fullScreen
        present(fullScreenImageVC, animated: true, completion: nil)
    }
    @objc func deleteButtonTapped() {
        print("\(feedbacks[selectedIndex].timestamp)")
        print("\(feedbacks[selectedIndex].userEmail)")
        
        let alert = UIAlertController(title: "Emin misin?", message: "Geri bildirim silinecek.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        
        let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
            self.db.collection("Feedbacks").document("\(feedbacks[self.selectedIndex].userEmail)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child("Feedbacks")
                    let images1Ref = imagesRef.child("\(feedbacks[self.selectedIndex].userEmail)/")
                    images1Ref.listAll { (result, error) in
                        if let error = error {
                            print("Error\(error)")
                        }
                        for item in result!.items {
                            let images2Ref = images1Ref.child("\(item.name)")
                            images2Ref.delete { error in
                                if let error = error {
                                    print("Uh-oh, an error occurred! \(error)")
                                } else {
                                    print("File deleted successfully")
                                }
                            }
                        }
                    }
                }
            }
            // Geri bildirim silindikten sonra Hesabım View'ına geri götürür.
            if let targetVC = self.navigationController?.viewControllers.first(where: { $0 is AccountViewController }) {
                self.navigationController?.popToViewController(targetVC, animated: true)
                }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        let labelPadding: CGFloat = 8
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            feedbackImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            feedbackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            feedbackImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            feedbackImageView.heightAnchor.constraint(equalTo: feedbackImageView.widthAnchor),
            
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: feedbackImageView.bottomAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabelContainer.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            contentLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabel.leadingAnchor.constraint(equalTo: contentLabelContainer.leadingAnchor, constant: labelPadding),
            contentLabel.topAnchor.constraint(equalTo: contentLabelContainer.topAnchor, constant: labelPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentLabelContainer.trailingAnchor, constant: -labelPadding),
            contentLabel.bottomAnchor.constraint(equalTo: contentLabelContainer.bottomAnchor, constant: -labelPadding),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            
            contentView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16)
        ])
    }
    
}
