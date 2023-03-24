import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage

class EditProductViewController1: UIViewController,UITextFieldDelegate,UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource , UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var productName = ""
    var productPrice = ""
    var productCategory = ""
    var productDetail = ""
    var selectedCategory = ""
    let firstCategory = collectionViewData[selectedItem].productCategory
    
    var image1 = UIImage(named: "logo")
    var image2 = UIImage(named: "logo")
    var image3 = UIImage(named: "logo")
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var productPriceTextField: UITextField!
    @IBOutlet var productDetailTextView: UITextView!
    @IBOutlet var productCategoryTextField: UITextField!
    @IBOutlet var productNameTextField: UITextField!
    
    let imgPicker = UIImagePickerController()
    
    @IBOutlet var scrollView: UIScrollView!
    let documentID = collectionViewData[selectedItem].productName
    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var numberOfPage = 3 // toplam sayfa sayısı
    var currentPage = 0
    var photoCount = 0
    let ratingView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductReviewTableViewCell.self, forCellReuseIdentifier: "productReviewCell")
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        
        commentsBrain = []
        hideKeyboardWhenTappedAround()
        setupPicker()
        dissmissAndClosePickerView()
        getCommentsData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        

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
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch photoCount {
        case 1:
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image2 = userPickedImage
                let newImageView = UIImageView(image: userPickedImage)
                let imageViewWidth = scrollView.frame.width
                let imageViewHeight = scrollView.frame.height
                let xCoordinate = CGFloat(photoCount) * imageViewWidth
                let yCoordinate: CGFloat = 0.0
                newImageView.frame = CGRect(x: xCoordinate, y: yCoordinate, width: imageViewWidth, height: imageViewHeight)
                newImageView.contentMode = .scaleAspectFit
                newImageView.image = userPickedImage
                scrollView.addSubview(newImageView)
                let contentWidth = imageViewWidth * CGFloat(photoCount + 1)
                scrollView.contentSize = CGSize(width: contentWidth, height: imageViewHeight)
                photoCount += 1
                numberOfPage += 1
                pageControl.numberOfPages = photoCount - 1
                pageLabel.text = "\(currentPage + 1) / \(numberOfPage)"
                imgPicker.dismiss(animated: true)
            }
        case 2:
            if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image3 = userPickedImage
                let newImageView = UIImageView(image: userPickedImage)
                let imageViewWidth = scrollView.frame.width
                let imageViewHeight = scrollView.frame.height
                let xCoordinate = CGFloat(photoCount) * imageViewWidth
                let yCoordinate: CGFloat = 0.0
                newImageView.frame = CGRect(x: xCoordinate, y: yCoordinate, width: imageViewWidth, height: imageViewHeight)
                newImageView.contentMode = .scaleAspectFit
                newImageView.image = userPickedImage
                scrollView.addSubview(newImageView)
                let contentWidth = imageViewWidth * CGFloat(photoCount + 1)
                scrollView.contentSize = CGSize(width: contentWidth, height: imageViewHeight)
                photoCount += 1
                numberOfPage += 1
                pageControl.numberOfPages = photoCount - 1
                pageLabel.text = "\(currentPage + 1) / \(numberOfPage)"
                imgPicker.dismiss(animated: true)
            }
        default:
            print("Error photoCount cannot found")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        currentPage = pageIndex
        pageControl.currentPage = currentPage
        pageLabel.text = "\(currentPage + 1) / \(numberOfPage)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: productPriceTextField.frame.maxY + 20, width: view.frame.width, height: 3 * 120)
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: tableView.frame.maxY + 120)
        saveButton.frame = CGRect(x: saveButton.frame.minX, y: mainScrollView.contentSize.height - saveButton.frame.height, width: saveButton.frame.width, height: saveButton.frame.height)
        if commentsBrain.count == 0 {
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: productPriceTextField.frame.maxY + 20, width: view.frame.width, height: 0 * 120)
            mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: productPriceTextField.frame.maxY + 114)
            saveButton.frame = CGRect(x: saveButton.frame.minX, y: mainScrollView.contentSize.height - saveButton.frame.height, width: saveButton.frame.width, height: saveButton.frame.height)
            
        }
    }
    
    @IBAction func deleteProduct(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Emin misin?", message: "Ürün Silinecek", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
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
            self.db.collection(self.user!).document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteImage1(_ sender: UIButton) {
        if pageControl.currentPage == 0 {
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
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                    image1 = image2
                    image2 = image3
                    image3 = UIImage(named: "logo")
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
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                    image1 = image2
                    image2 = UIImage(named: "logo")
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
            if let imageView2  = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst().first as? UIImageView {
                if photoCount == 3 {
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView2.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView3!.frame.width , height: scrollView.contentSize.height)
                    pageControl.numberOfPages = 2
                    numberOfPage = 2
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                    image2 = image3
                    image3 = UIImage(named: "logo")
                }
                if photoCount == 2 {
                    let imageView3 = scrollView.subviews.filter({ $0 is UIImageView }).dropFirst(2).first as? UIImageView
                    imageView3?.frame = CGRect(x: (imageView3?.frame.minX)! - (imageView3?.frame.width)! , y: 0, width: (imageView3?.frame.width)!, height: (imageView3?.frame.height)!)
                    imageView2.removeFromSuperview()
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width - imageView2.frame.width , height: scrollView.contentSize.height)
                    pageControl.numberOfPages = photoCount - 1
                    pageLabel.text = "\(currentPage + 1) / \(photoCount - 1)"
                    image2 = UIImage(named: "logo")
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
                    image3 = UIImage(named: "logo")
                }
            }
            photoCount -= 1
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        if photoCount == 3 {
            let alert = UIAlertController(title: "Uyarı!", message: "Maksimum 3 fotoğraf ekleyebilirsin.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Tamam", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            present(imgPicker, animated: true, completion: nil)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentsBrain.count != 0{
            return commentsBrain.count
        }else{
            return 0
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productReviewCell", for: indexPath) as! ProductReviewTableViewCell
        if commentsBrain.count != 0{
            
            // Configure the cell with the review data
            let review = commentsBrain[indexPath.row]
            let myDate = Date(timeIntervalSince1970: TimeInterval(review.Date))
            cell.configure(name: review.Name, rating: Double(review.Rate), comment: review.Comment, date: myDate)
            // Add the review date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let reviewDate = Date(timeIntervalSince1970: myDate.timeIntervalSince1970)
            cell.detailTextLabel?.text = dateFormatter.string(from: reviewDate)
            return cell
        }else{
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Yorum silinecek", message: "Onaylıyor musun?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)
        let okAction = UIAlertAction(title: "Onayla", style: .default) { _ in
            self.db.collection(self.user!).document("Comments").collection(self.documentID).document( commentsBrain[indexPath.row].Documentid).delete()
            commentsBrain.remove(at:  indexPath.row)
            tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getCommentsData(){
        db.collection(user!).document("Comments").collection(documentID).getDocuments { QuerySnapshot, errr in
            if let errr = errr {
                print(errr)
            }else{
                let data1 = QuerySnapshot?.documents
                for dcmnt in data1!{
                    let data = dcmnt.data()
                    if let comment = data["Comment"] as? String ,let date = data["Date"] as? Int , let name = data["Name"] as? String, let rate = data["Rate"] as? Double , let id = data["Documentid"] as? String{
                        let cmmnt = commentBrain(Comment: comment, Date: Double(date), Rate: Double(rate), Name: name,Documentid: id)
                        commentsBrain.append(cmmnt)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            if commentsBrain.count != 0 {
                // Add rating view
                let ratingView = UIView()
                ratingView.backgroundColor = .white
                ratingView.layer.cornerRadius = 8.0
                ratingView.layer.shadowColor = UIColor.black.cgColor
                ratingView.layer.shadowOffset = CGSize(width: 0, height: 2)
                ratingView.layer.shadowOpacity = 0.2
                ratingView.layer.shadowRadius = 2.0
                ratingView.translatesAutoresizingMaskIntoConstraints = false
                mainScrollView.addSubview(ratingView)
                
                // Add rating stars
                let filledStarImage = UIImage(systemName: "star.fill")
                let emptyStarImage = UIImage(systemName: "star")
                let ratingStarsStackView = UIStackView()
                ratingStarsStackView.axis = .horizontal
                ratingStarsStackView.alignment = .fill
                ratingStarsStackView.distribution = .fillEqually
                ratingStarsStackView.spacing = 4.0
                ratingStarsStackView.translatesAutoresizingMaskIntoConstraints = false
                ratingView.addSubview(ratingStarsStackView)
                
                
                for i in 1...5 {
                    let starImageView = UIImageView()
                    starImageView.tintColor = UIColor.systemYellow
                    starImageView.contentMode = .scaleAspectFit
                    starImageView.translatesAutoresizingMaskIntoConstraints = false
                    
                    if Int(Double(i)) <= Int(commentsBrain[0].Rate) {
                        starImageView.image = filledStarImage
                    } else {
                        starImageView.image = emptyStarImage
                    }
                    
                    ratingStarsStackView.addArrangedSubview(starImageView)
                    
                    // Add constraints for the star image view
                    starImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                    starImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
                }
                
                func getAverageRate() -> Double {
                    var totalRate = 0.0
                    for comment in commentsBrain {
                        totalRate += Double(comment.Rate)
                    }
                    let averageRate = Double(totalRate) / Double(commentsBrain.count)
                    return averageRate
                }
                let averageRate = getAverageRate()
                let ratingLabel = UILabel()
                ratingLabel.text = String(format: "%.1f", averageRate)
                ratingLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                
                ratingLabel.textColor = .darkGray
                ratingLabel.textAlignment = .center
                ratingLabel.translatesAutoresizingMaskIntoConstraints = false
                ratingView.addSubview(ratingLabel)
                
                // Add constraints for the rating label
                ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsStackView.trailingAnchor, constant: 10.0).isActive = true
                ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsStackView.centerYAnchor).isActive = true
                
                // Add constraints for the rating stars stack view
                ratingStarsStackView.topAnchor.constraint(equalTo: ratingView.topAnchor).isActive = true
                ratingStarsStackView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor).isActive = true
                ratingStarsStackView.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor).isActive = true
                // Add constraints for rating view
                let horizontalSpacing: CGFloat = 20.0
                ratingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing).isActive = true
                ratingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing).isActive = true
                ratingView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15.0).isActive = true
                ratingView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                ratingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
            }
        }
        
    }
    @IBAction func saveChanges(_ sender: UIButton) {
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
        
        if image1 != UIImage(named: "logo") {
            // İlk fotoğrafı yükleme
            if let imageone = self.image1 {
                let storageRef = self.storage.reference()
                let imagesRef = storageRef.child(self.user!)
                let images1Ref = imagesRef.child("Products")
                let images2Ref = images1Ref.child(productCategoryTextField.text!)
                let images3Ref = images2Ref.child(productNameTextField.text!)
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
        }
        if image2 != UIImage(named: "logo"){
            // İkinci fotoğrafı yükleme
            if let imagetwo = self.image2 {
                let storageRef = self.storage.reference()
                let imagesRef = storageRef.child(self.user!)
                let images1Ref = imagesRef.child("Products")
                let images2Ref = images1Ref.child(productCategoryTextField.text!)
                let images3Ref = images2Ref.child(productNameTextField.text!)
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
        }
        if image3 != UIImage(named: "logo"){
            // Üçüncü fotoğrafı yükleme
            if let imagethree = self.image2 {
                let storageRef = self.storage.reference()
                let imagesRef = storageRef.child(self.user!)
                let images1Ref = imagesRef.child("Products")
                let images2Ref = images1Ref.child(productCategoryTextField.text!)
                let images3Ref = images2Ref.child(productNameTextField.text!)
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
        }
        
        // Update the product information and images in the database
        if let name = productNameTextField.text, let price = productPriceTextField.text, let detail = productDetailTextView.text, let category = productCategoryTextField.text {
            //Delete old informations
            let shouldDelete = db.collection(user!).document("Products").collection(firstCategory).document(documentID)
            shouldDelete.delete()
            
            // Update the product information
            db.collection(user!).document("Products").collection(category).document(name).setData([
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
