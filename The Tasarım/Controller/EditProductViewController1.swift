import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage

class EditProductViewController1: UIViewController,UITextFieldDelegate,UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    
    
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var productName = ""
    var productPrice = ""
    var productCategory = ""
    var productDetail = ""
    var selectedCategory = ""
    var image1 = UIImage(named: "logo")
    var image2 = UIImage(named: "logo")
    var image3 = UIImage(named: "logo")
    
    @IBOutlet var productPriceTextField: UITextField!
    @IBOutlet var productDetailTextView: UITextView!
    @IBOutlet var productCategoryTextField: UITextField!
    @IBOutlet var productNameTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    let documentID = collectionViewData[selectedItem].productName
    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var numberOfPage = 3 // toplam sayfa sayısı
    var currentPage = 0
    var photoCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupPicker()
        dissmissAndClosePickerView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        scrollView.delegate = self
        
        productNameTextField.text = collectionViewData[selectedItem].productName
        productPriceTextField.text = collectionViewData[selectedItem].productPrice
        productDetailTextView.text = collectionViewData[selectedItem].productDetail
        productCategoryTextField.text = collectionViewData[selectedItem].productCategory
        
        image1 = collectionViewData[selectedItem].image1
        image2 = collectionViewData[selectedItem].image2
        image3 = collectionViewData[selectedItem].image3
        
        
        
        if image1 != UIImage(named: "logo") {
            photoCount += 1
        }
        
        if image2 != UIImage(named: "logo") {
            photoCount += 1
        }
        
        if image3 != UIImage(named: "logo") {
            photoCount += 1
        }
        
        let imageViewWidth = scrollView.frame.width
        let imageViewHeight = scrollView.frame.height
        scrollView.contentSize = CGSize(width: imageViewWidth * CGFloat(photoCount), height: imageViewHeight)
        
        var xCoordinate: CGFloat = 0.0
        
        if let image1 = image1 , image1 != UIImage(named: "logo") {
            let newImageView1 = UIImageView(image: image1)
            newImageView1.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            newImageView1.contentMode = .scaleAspectFit
            scrollView.addSubview(newImageView1)
            xCoordinate += imageViewWidth
        }
        
        if let image2 = image2 , image2 != UIImage(named: "logo") {
            let newImageView2 = UIImageView(image: image2)
            newImageView2.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            newImageView2.contentMode = .scaleAspectFit
            scrollView.addSubview(newImageView2)
            xCoordinate += imageViewWidth
        }
        
        if let image3 = image3 ,image3 != UIImage(named: "logo")  {
            let newImageView3 = UIImageView(image: image3)
            newImageView3.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            newImageView3.contentMode = .scaleAspectFit
            scrollView.addSubview(newImageView3)
        }
        numberOfPage = photoCount
        pageControl.numberOfPages = numberOfPage
        pageControl.currentPage = currentPage
        pageLabel.text = "\(currentPage + 1) / \(numberOfPage)"
        print(photoCount)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        currentPage = pageIndex
        pageControl.currentPage = currentPage
        pageLabel.text = "\(currentPage + 1) / \(numberOfPage)"
    }
    
    @IBAction func deleteProduct(_ sender: UIBarButtonItem) {
        // Delete from storage
        let storageRef = self.storage.reference()
        let imagesRef = storageRef.child(self.user!)
        let images1Ref = imagesRef.child("Products")
        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
        let images3Ref = images2Ref.child(self.documentID)
        let images4Ref = images3Ref.child("image1")
        let images5Ref = images3Ref.child("image2")
        let images6Ref = images3Ref.child("image3")
        images4Ref.delete { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
                print("file deleted")
            }
        }
        images5Ref.delete { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
                print("file deleted")
            }
        }
        images6Ref.delete { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
                print("file deleted")
            }
        }
        // Delete from Database
        db.collection(self.user!).document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func deleteImage1(_ sender: UIButton) {
        if pageControl.currentPage == 0 {
            image1 = UIImage(named: "logo")
            let subviews = scrollView.subviews.filter { $0 is UIImageView }
            if let imageView1 = subviews.first {
                
                
                if photoCount == 3 {
                    // Scroll View sıralaması ayarlama
                    let imageView2  = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst().first as? UIImageView
                    imageView2!.frame = CGRect(x: (imageView2?.frame.maxX)! - (imageView2?.frame.width)! - (imageView2?.frame.width)! , y: 0, width: (imageView2?.frame.width)!, height: (imageView2?.frame.height)!)
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView1.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView1.frame.width , height: scrollView.contentSize.height)
                    numberOfPage = 2
                    pageControl.numberOfPages = 2
                    //Eski fotoğrafları silme
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child(self.user!)
                    let images1Ref = imagesRef.child("Products")
                    let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                    let images3Ref = images2Ref.child(self.documentID)
                    let images4Ref = images3Ref.child("image2")
                    let images5Ref = images3Ref.child("image3")
                    let images6Ref = images3Ref.child("image1")
                    // Delete the file
                    images6Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    images5Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    images4Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    
                    
                    // Yeni fotoğrafları yükleme
                    // İlk fotoğraf
                    if let imageone = self.image2 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
                        let images4Ref = images3Ref.child("image1")
                        
                        guard let imageData = imageone.jpegData(compressionQuality: 0.8) else {
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
                    // İkinci fotoğraf
                    if let imagethree = self.image3 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
                        let images4Ref = images3Ref.child("image2")
                        
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
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                    
                }
                if photoCount == 2 {
                    // Scroll View sıralaması ayarlama
                    let imageView2  = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst().first as? UIImageView
                    imageView2!.frame = CGRect(x: (imageView2?.frame.maxX)! - (imageView2?.frame.width)! - (imageView2?.frame.width)! , y: 0, width: (imageView2?.frame.width)!, height: (imageView2?.frame.height)!)
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView1.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView1.frame.width , height: scrollView.contentSize.height)
                    numberOfPage = 2
                    pageControl.numberOfPages = 2
                    //Eski fotoğrafları silme
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child(self.user!)
                    let images1Ref = imagesRef.child("Products")
                    let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                    let images3Ref = images2Ref.child(self.documentID)
                    let images4Ref = images3Ref.child("image2")
                    let images6Ref = images3Ref.child("image1")
                    // Delete the file
                    images6Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    images4Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    // Yeni fotoğrafları yükleme
                    if let imageone = self.image2 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
                        let images4Ref = images3Ref.child("image1")
                        
                        guard let imageData = imageone.jpegData(compressionQuality: 0.8) else {
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
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                }
                if photoCount == 1 {
                    let alert = UIAlertController(title: "Emin misin?", message: "Ürünü tek fotoğrafını silmek üzeresin, Ürün uygulamadan silinecek.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
                    let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
                        // Scroll View sıralaması ayarlama
                        let imageView2  = self.scrollView.subviews.filter({ $0 is UIImageView }).dropFirst().first as? UIImageView
                        imageView2?.frame = CGRect(x: (imageView2?.frame.maxX)! - (imageView2?.frame.width)! - (imageView2?.frame.width)! , y: 0, width: (imageView2?.frame.width)!, height: (imageView2?.frame.height)!)
                        let imageView3 = self.scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                        imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                        imageView1.removeFromSuperview()
                        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width - imageView1.frame.width , height: self.scrollView.contentSize.height)
                        self.numberOfPage = 2
                        self.pageControl.numberOfPages = 2
                        //Eski fotoğrafları storageden silme
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
                        let images4Ref = images3Ref.child("image1")
                        let images5Ref = images3Ref.child("image2")
                        let images6Ref = images3Ref.child("image3")
                        
                        images4Ref.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                // File deleted successfully
                                print("file deleted")
                            }
                        }
                        images5Ref.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                // File deleted successfully
                                print("file deleted")
                            }
                        }
                        images6Ref.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                // File deleted successfully
                                print("file deleted")
                            }
                        }
                        // Delete from Database
                        self.db.collection(self.user!).document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                    photoCount += 1
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                photoCount -= 1
                collectionViewData[selectedItem].image1 = UIImage(named: "logo")!
            }
        }
        if pageControl.currentPage == 1 {
            
            image2 = UIImage(named: "logo")
            if let imageView2  = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst().first as? UIImageView {
                if photoCount == 3 {
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView2.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView3!.frame.width , height: scrollView.contentSize.height)
                    pageControl.numberOfPages = 2
                    numberOfPage = 2
                    
                    //Eski fotoğrafları silme
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child(self.user!)
                    let images1Ref = imagesRef.child("Products")
                    let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                    let images3Ref = images2Ref.child(self.documentID)
                    let images4Ref = images3Ref.child("image2")
                    let images5Ref = images3Ref.child("image3")
                    let images6Ref = images3Ref.child("image1")
                    // Delete the file
                    images6Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    images5Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    images4Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    //Yeni fotoğrafları ekleme
                    //İlk fotoğraf yükleme
                    
                    if let imageone = self.image1 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
                        let images4Ref = images3Ref.child("image1")
                        
                        guard let imageData = imageone.jpegData(compressionQuality: 0.8) else {
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
                    //İkinci fotoğraf yükleme
                    if let imagetwo = self.image3 {
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child(self.user!)
                        let images1Ref = imagesRef.child("Products")
                        let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                        let images3Ref = images2Ref.child(self.documentID)
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
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                }
                if photoCount == 2 {
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView2.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView2.frame.width , height: scrollView.contentSize.height)
                    //Eski fotoğrafları storageden silme
                    //İkinci fotoğrafı silme
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child(self.user!)
                    let images1Ref = imagesRef.child("Products")
                    let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                    let images3Ref = images2Ref.child(self.documentID)
                    let images6Ref = images3Ref.child("image2")
                    // Delete the file
                    images6Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                }
            }
            photoCount -= 1
            collectionViewData[selectedItem].image2 = UIImage(named: "logo")!
        }
        if pageControl.currentPage == 2 {
            collectionViewData[selectedItem].image3 = UIImage(named: "logo")!
            image3 = UIImage(named: "logo")
            if let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView {
                if photoCount == 3 {
                    imageView3.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView3.frame.width , height: scrollView.contentSize.height)
                    pageControl.numberOfPages = 2
                    pageControl.currentPage = 1
                    numberOfPage = 2
                    
                    //Eski fotoğrafları silme
                    // Üçüncü fotoğrafı silme
                    let storageRef = self.storage.reference()
                    let imagesRef = storageRef.child(self.user!)
                    let images1Ref = imagesRef.child("Products")
                    let images2Ref = images1Ref.child(collectionViewData[selectedItem].productCategory)
                    let images3Ref = images2Ref.child(self.documentID)
                    let images4Ref = images3Ref.child("image3")
                    // Delete the file
                    images4Ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            // File deleted successfully
                            print("file deleted")
                        }
                    }
                }
            }
            photoCount -= 1
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func saveChanges(_ sender: UIButton) {
        // Update the product information and images in the database
        if let name = productNameTextField.text, let price = productPriceTextField.text, let detail = productDetailTextView.text, let category = productCategoryTextField.text {
            // Update the product information
            db.collection(user!).document("Products").collection(category).document(documentID).setData([
                "name": name,
                "price": price,
                "detail": detail
            ], merge: true) { error in
                if let error = error {
                    print("Error updating product information: \(error.localizedDescription)")
                    
                    // Display an error message if the update failed
                    let alert = UIAlertController(title: "Error", message: "Failed to update product information.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Product information updated successfully.")
                }
            }
            // Display a success message and return to the previous view controller
            let alert = UIAlertController(title: "Success", message: "Product information updated successfully.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    func dissmissAndClosePickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain,target: self,action: #selector(self.dissmissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.productCategoryTextField.inputAccessoryView = toolBar
    }
    @objc func dissmissAction(){
        self.view.endEditing(true)
    }
    func setupPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        productCategoryTextField.inputView = pickerView
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
        productCategoryTextField.text = selectedCat
        selectedCategory = selectedCat
        print(selectedCategory)
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
