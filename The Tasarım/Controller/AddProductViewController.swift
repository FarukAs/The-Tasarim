//
//  AddProductViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 14.02.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextViewDelegate,UITextFieldDelegate , UIPickerViewDelegate ,UIPickerViewDataSource {
    
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let userID = Auth.auth().currentUser?.uid
    var image1 : UIImage?
    var image2 : UIImage?
    var image3 : UIImage?
    let imagePicker = UIImagePickerController()
    
    var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        hideKeyboardWhenTappedAround()
        setupPicker()
        dissmissAndClosePickerView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        print(productCategories)
        
    }
    
    
    @IBAction func addPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photoCount = scrollView.subviews.filter { $0 is UIImageView }.count
        if photoCount == 0 {
            if var userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
       
                let newImageView = UIImageView(image: userPickedImage)
                image1 = userPickedImage
                print(photoCount)
                let imageViewWidth = scrollView.frame.width
                let imageViewHeight = scrollView.frame.height
                let xCoordinate = CGFloat(photoCount) * imageViewWidth
                let yCoordinate: CGFloat = 0.0
                newImageView.frame = CGRect(x: xCoordinate, y: yCoordinate, width: imageViewWidth, height: imageViewHeight)
                newImageView.contentMode = .scaleAspectFit
                scrollView.addSubview(newImageView)
                print(photoCount)
                let contentWidth = imageViewWidth * CGFloat(photoCount + 1)
                scrollView.contentSize = CGSize(width: contentWidth, height: imageViewHeight)
            }
            imagePicker.dismiss(animated: true)
        }
        if photoCount == 1{
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let newImageView = UIImageView(image: userPickedImage)
                image2 = userPickedImage
                print(photoCount)
                let imageViewWidth = scrollView.frame.width
                let imageViewHeight = scrollView.frame.height
                let xCoordinate = CGFloat(photoCount) * imageViewWidth
                let yCoordinate: CGFloat = 0.0
                newImageView.frame = CGRect(x: xCoordinate, y: yCoordinate, width: imageViewWidth, height: imageViewHeight)
                newImageView.contentMode = .scaleAspectFit
                scrollView.addSubview(newImageView)
                print(photoCount)
                let contentWidth = imageViewWidth * CGFloat(photoCount + 1)
                scrollView.contentSize = CGSize(width: contentWidth, height: imageViewHeight)
            }
            imagePicker.dismiss(animated: true)
        }
        if photoCount == 2{
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let newImageView = UIImageView(image: userPickedImage)
                image3 = userPickedImage
                print(photoCount)
                let imageViewWidth = scrollView.frame.width
                let imageViewHeight = scrollView.frame.height
                let xCoordinate = CGFloat(photoCount) * imageViewWidth
                let yCoordinate: CGFloat = 0.0
                newImageView.frame = CGRect(x: xCoordinate, y: yCoordinate, width: imageViewWidth, height: imageViewHeight)
                newImageView.contentMode = .scaleAspectFit
                scrollView.addSubview(newImageView)
                print(photoCount)
                let contentWidth = imageViewWidth * CGFloat(photoCount + 1)
                scrollView.contentSize = CGSize(width: contentWidth, height: imageViewHeight)
            }
            imagePicker.dismiss(animated: true)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        
        if  let name = nameTextField.text , let detail = detailTextView.text , let price = priceTextField.text {
            
            db.collection(user!).document("Products").collection(selectedCategory).document(name).setData([
                "category": selectedCategory,
                "name": name,
                "detail": detail,
                "price": price
            ]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    //Fotoğraf kaydetme
                    
                    if let imageone = self.image1 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(self.selectedCategory)
                        let images3Ref = images2Ref.child(name)
                        let images4Ref = images3Ref.child("image1")
                        
                        guard let imageData = imageone.jpegData(compressionQuality: 0.8) else {
                            return
                        }
                        // Fotoğrafı yükleyin
                        images4Ref.putData(imageData, metadata: nil) { (metadata, error) in
                            guard let _ = metadata else {
                                print("metadata error \(String(describing: error))")
                                return
                            }
                        }
                    }
                    if let imagetwo = self.image2 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(self.selectedCategory)
                        let images3Ref = images2Ref.child(name)
                        let images4Ref = images3Ref.child("image2")
                        
                        guard let imageData = imagetwo.jpegData(compressionQuality: 0.8) else {
                            return
                        }
                        // Fotoğrafı yükleyin
                        _ = images4Ref.putData(imageData, metadata: nil) { (metadata, error) in
                            guard let _ = metadata else {
                                print("metadata error \(String(describing: error))")
                                return
                            }
                        }
                    }
                    if let imagethree = self.image3 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(self.selectedCategory)
                        let images3Ref = images2Ref.child(name)
                        let images4Ref = images3Ref.child("image3")
                        
                        guard let imageData = imagethree.jpegData(compressionQuality: 0.8) else {
                            return
                        }
                        // Fotoğrafı yükleyin
                        _ = images4Ref.putData(imageData, metadata: nil) { (metadata, error) in
                            guard let _ = metadata else {
                                print("metadata error \(String(describing: error))")
                                return
                            }
                        }
                    }
                    let alertController = UIAlertController(title: "Ürün Eklendi, Lütfen uygulamayı yeniden başlatın.", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
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
    func dissmissAndClosePickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain,target: self,action: #selector(self.dissmissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.categoryTextField.inputAccessoryView = toolBar
    }
    @objc func dissmissAction(){
        self.view.endEditing(true)
    }
    func setupPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return productCategories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCat = productCategories[row]
        categoryTextField.text = selectedCat
        selectedCategory = selectedCat
        print(selectedCategory)
    }
    
    
    
    
    
    
    
    
    
    
    func compressImage(image: UIImage, compressionQuality: CGFloat) -> Data? {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        return data
    }

}



