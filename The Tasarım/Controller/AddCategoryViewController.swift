//
//  AddCategoryViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 15.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImageWebPCoder
class AddCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextViewDelegate ,UITextFieldDelegate {
    
    @IBOutlet var categoryTextField: UITextField!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    let imagePicker = UIImagePickerController()
    var image : UIImage?
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func addPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = userPickedImage
            imageView.image = userPickedImage
            imagePicker.dismiss(animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addCategory(_ sender: UIButton) {
        
        if let category = self.categoryTextField.text {
            let newRef = db.collection("Category").document(category)
            
            newRef.setData(["9999" : "9999"])
            //Fotoğraf kaydetme
            
            if let imageone = self.image {
                let storageRef = self.storage.reference()
                let imagesRef = storageRef.child(self.user!)
                let images1Ref = imagesRef.child("Category")
                let images2Ref = images1Ref.child(category)
                let images3Ref = images2Ref.child("categoryImage")
                
                if let imageData = imageone.sd_imageData(as: .webP, compressionQuality: 0.1){
                    // Fotoğrafı yükleyin
                    _ = images3Ref.putData(imageData, metadata: nil) { (metadata, error) in
                        guard let _ = metadata else {
                            print("metadata error \(String(describing: error))")
                            return
                        }
                    }
                }
            }
            //Databasedeki toplam kategori sayısını güncelleme
            self.db.collection("developer@gmail.com").document("numberofitems").getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let numberofcategory = data!["category"] as! Int
                    let numberofproduct = data!["product"] as! Int
                    
                    self.db.collection("developer@gmail.com").document("numberofitems").setData(["category" : numberofcategory + 1, "product": numberofproduct])
                } else {
                    print("Document does not exist")
                }
            }
            let alertController = UIAlertController(title: "Kategori Eklendi.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
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
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
