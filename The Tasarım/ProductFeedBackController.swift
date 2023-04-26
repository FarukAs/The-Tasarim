//
//  ProductFeedBackController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 15.04.2023.
//

//
//  fbgecici.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 14.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
class ProductFeedBackController: UIViewController {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let titleLabel = UILabel()
    let closeButton = UIButton()
    let stackView = UIStackView()
    let View = UIView()
    let backgroundView = UIView()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Popup view özellikleri
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(backgroundView)
        view.addSubview(View)
        View.addSubview(titleLabel)
        View.addSubview(closeButton)
        View.addSubview(stackView)
        
        
        backgroundView.frame = view.bounds
        backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -View.frame.height).isActive = true
        
        View.backgroundColor = .white
        View.layer.cornerRadius = 15
        View.translatesAutoresizingMaskIntoConstraints = false
        View.topAnchor.constraint(equalTo: titleLabel.topAnchor,constant: -25).isActive = true
        View.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        View.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        View.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        // Başlık özellikleri
        titleLabel.text = "Geri bildirim nedenini seçiniz"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: View.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16).isActive = true
        
        // Kapatma butonu özellikleri
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: View.trailingAnchor, constant: -16).isActive = true
        
        // Seçenekler özellikleri
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,    constant: 25).isActive = true
        stackView.leadingAnchor.constraint(equalTo: View.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: View.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: View.bottomAnchor, constant: -35).isActive = true
        
        // Geri bildirim seçenekleri
        let option1Button = UIButton()
        option1Button.setTitle("Ürünün fiyatı hatalı", for: .normal)
        option1Button.layer.cornerRadius = 5
        option1Button.setTitleColor(.black, for: .normal)
        option1Button.backgroundColor = .lightGray
        option1Button.addTarget(self, action: #selector(feedbackOptionSelected), for: .touchUpInside)
        option1Button.tag = 1
        
        let option2Button = UIButton()
        option2Button.setTitle("Görsel hatalı", for: .normal)
        option2Button.layer.cornerRadius = 5
        option2Button.setTitleColor(.black, for: .normal)
        option2Button.backgroundColor = .lightGray
        option2Button.addTarget(self, action: #selector(feedbackOptionSelected), for: .touchUpInside)
        option2Button.tag = 2
        
        let option3Button = UIButton()
        option3Button.setTitle("Ürünün ismi eksik/hatalı", for: .normal)
        option3Button.layer.cornerRadius = 5
        option3Button.setTitleColor(.black, for: .normal)
        option3Button.backgroundColor = .lightGray
        option3Button.addTarget(self, action: #selector(feedbackOptionSelected), for: .touchUpInside)
        option3Button.tag = 3
        
        let option4Button = UIButton()
        option4Button.setTitle("Ürünün özellikleri eksik ya da hatalı", for: .normal)
        option4Button.layer.cornerRadius = 5
        option4Button.setTitleColor(.black, for: .normal)
        option4Button.backgroundColor = .lightGray
        option4Button.addTarget(self, action: #selector(feedbackOptionSelected), for: .touchUpInside)
        option4Button.tag = 4
        
        // Geri bildirim seçeneklerini stackView'e ekleme
        stackView.addArrangedSubview(option1Button)
        stackView.addArrangedSubview(option2Button)
        stackView.addArrangedSubview(option3Button)
        stackView.addArrangedSubview(option4Button)
    }
    
    @objc func feedbackOptionSelected(sender: UIButton) {
        switch sender.tag {
        case 1:
            self.db.collection("developer@gmail.com").document("specificFeedback").collection(self.user!).addDocument(data: [collectionViewData[self.selectedIndex!].productName : "Ürünün fiyatı hatalı"])
        case 2:
            self.db.collection("developer@gmail.com").document("specificFeedback").collection(self.user!).addDocument(data: [collectionViewData[self.selectedIndex!].productName : "Görsel hatalı"])
        case 3:
            self.db.collection("developer@gmail.com").document("specificFeedback").collection(self.user!).addDocument(data: [collectionViewData[self.selectedIndex!].productName : "Ürünün ismi eksik/hatalı"])
        case 4:
            self.db.collection("developer@gmail.com").document("specificFeedback").collection(self.user!).addDocument(data: [collectionViewData[self.selectedIndex!].productName : "Ürünün özellikleri eksik ya da hatalı"])
        default:
            break
        }
        let feedbackReceivedView = createFeedbackReceivedView()
            self.view.addSubview(feedbackReceivedView)
            NSLayoutConstraint.activate([
                feedbackReceivedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                feedbackReceivedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                feedbackReceivedView.widthAnchor.constraint(equalToConstant: 250),
            ])

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                feedbackReceivedView.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @objc func dissmiss() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        dismiss(animated: true, completion: nil)
    }
    func createFeedbackReceivedView() -> UIView {
        let feedbackReceivedView = UIView()
        feedbackReceivedView.backgroundColor = UIColor.white
        feedbackReceivedView.layer.cornerRadius = 10
        feedbackReceivedView.translatesAutoresizingMaskIntoConstraints = false

        // Create the UIImageView for the green checkmark (tick) image
        let tickImageView = UIImageView()
        tickImageView.image = UIImage(named: "green_checkmark") // Replace "green_checkmark" with the actual image name in your assets catalog
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.contentMode = .scaleAspectFit

        let message1Label = UILabel()
        message1Label.text = "Geri bildiriminiz alındı"
        message1Label.textColor = .green
        message1Label.font = UIFont.boldSystemFont(ofSize: 18)
        message1Label.numberOfLines = 0
        message1Label.translatesAutoresizingMaskIntoConstraints = false

        let message2Label = UILabel()
        message2Label.text = "Geri bildiriminiz için teşekkür ederiz"
        message2Label.textColor = .black
        message2Label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        message2Label.numberOfLines = 0
        message2Label.textAlignment = .center
        message2Label.translatesAutoresizingMaskIntoConstraints = false

        feedbackReceivedView.addSubview(tickImageView)
        feedbackReceivedView.addSubview(message1Label)
        feedbackReceivedView.addSubview(message2Label)

        NSLayoutConstraint.activate([
            tickImageView.centerXAnchor.constraint(equalTo: feedbackReceivedView.centerXAnchor),
            tickImageView.topAnchor.constraint(equalTo: feedbackReceivedView.topAnchor, constant: 8),
            tickImageView.widthAnchor.constraint(equalToConstant: 40),
            tickImageView.heightAnchor.constraint(equalToConstant: 40),

            message1Label.centerXAnchor.constraint(equalTo: feedbackReceivedView.centerXAnchor),
            message1Label.topAnchor.constraint(equalTo: tickImageView.bottomAnchor, constant: 8),

            message2Label.topAnchor.constraint(equalTo: message1Label.bottomAnchor, constant: 4),
            message2Label.leadingAnchor.constraint(equalTo: feedbackReceivedView.leadingAnchor, constant: 10),
            message2Label.trailingAnchor.constraint(equalTo: feedbackReceivedView.trailingAnchor, constant: -10),
            message2Label.bottomAnchor.constraint(equalTo: feedbackReceivedView.bottomAnchor,constant: -10)
        ])

        return feedbackReceivedView
    }


}
