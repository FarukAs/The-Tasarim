//
//  FeedBackViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 27.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FeedBackViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextViewDelegate {
    
    @IBOutlet var successLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var textView: UITextView!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let userEmail = Auth.auth().currentUser?.email
    let imagePicker = UIImagePickerController()
    var myImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        hideKeyboardWhenTappedAround()
        navigationItem.title = "Geri Bildirim"
        
        sendButton.layer.cornerRadius = 18
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        sendButton.layer.shadowRadius = 10
        sendButton.layer.shadowOpacity = 0.3
        
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.backgroundColor = UIColor.white
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.clipsToBounds = false
        textView.layer.masksToBounds = false
        successLabel.isHidden = true
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            successLabel.isHidden = false
            myImage = userPickedImage
        }
        
        imagePicker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Düşünceleriniz" {
            textView.text = ""
        }
    }
    @IBAction func sendFeedBack(_ sender: UIButton) {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        db.collection("Feedbacks").document("\(userEmail!)").setData([timestamp: 1])
        self.db.collection("Feedbacks").document("\(userEmail!)").collection(timestamp).document("Feedback").setData([timestamp: textView.text!]) { (error) in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                print("User added successfully!")

                if let newImage = self.myImage {
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child("Feedbacks")
                    let images1Ref = imagesRef.child(self.userEmail!)
                    let images2Ref = images1Ref.child(timestamp)

                    // Sıkıştırma kalitesini düşük bir değere ayarlayarak fotoğrafın boyutunu azaltın
                    guard let imageData = newImage.jpegData(compressionQuality: 0.1) else {
                        return
                    }
                    // Fotoğrafı yükleyin
                    images2Ref.putData(imageData, metadata: nil) { (metadata, error) in
                        guard let _ = metadata else {
                            print("metadata error \(String(describing: error))")
                            return
                        }
                    }
                }

                let alert = UIAlertController(title: "Başarılı", message: "Geri bildirim gönderildi.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                self.textView.text = ""
                self.successLabel.isHidden = true
                self.sendButton.backgroundColor = .green

                // 1 saniye sonra eski rengine dön
                UIView.animate(withDuration: 6) {
                    self.sendButton.backgroundColor = .lightGray
                }

            }
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
