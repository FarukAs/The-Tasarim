import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage

class EditProductViewController1: UIViewController,UITextFieldDelegate,UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource , UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var mainScrollView = UIScrollView()
    private var contentView = UIView()
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var pageLabel = UILabel()
    private var addPhotoButton = UIButton()
    private var deleteImageButton = UIButton()
    private var productCategoryTextField = UITextField()
    private var productNameTextField = UITextField()
    private var productDetailTextView = UITextView()
    private var productPriceTextField = UITextField()
    private var productStockTextField = UITextField()
    private var tableView = UITableView()
    private var ratingView = UIView()
    private var saveButton = UIButton()
    
    var productName = ""
    var productPrice = ""
    var productCategory = ""
    var productDetail = ""
    var selectedCategory = ""
    let firstCategory = collectionViewData[selectedItem].productCategory
    
    var image1 = UIImage(named: "logo")
    var image2 = UIImage(named: "logo")
    var image3 = UIImage(named: "logo")
    
    let imgPicker = UIImagePickerController()
    let documentID = collectionViewData[selectedItem].productName
    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var numberOfPage = 3 // toplam sayfa sayısı
    var currentPage = 0
    var photoCount = 0
    var average = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        applyConstraints()
        
        commentsBrain = []
        hideKeyboardWhenTappedAround()
        setupPicker()
        dissmissAndClosePickerView()
        getCommentsData()
        
        viewDidLoadSettings()
        setupImages()
    }
    private func setupImages() {
        image1 = collectionViewData[selectedItem].image1
        image2 = collectionViewData[selectedItem].image2
        image3 = collectionViewData[selectedItem].image3
        var images: [UIImage?] = []
        
        if let image1 = image1, image1 != UIImage(named: "logo") {
            images.append(image1)
        }
        
        if let image2 = image2, image2 != UIImage(named: "logo") {
            images.append(image2)
        }
        
        if let image3 = image3, image3 != UIImage(named: "logo") {
            images.append(image3)
        }
        setupScrollView(with: images)
    }
    
    private func setupScrollView(with images: [UIImage?]) {
        let imageViewWidth = view.frame.width - 120
        let imageViewHeight = view.frame.height / 4
        let numberOfImages = images.count
        scrollView.contentSize = CGSize(width: CGFloat(imageViewWidth) * CGFloat(numberOfImages), height: CGFloat(imageViewHeight))
        for (index, image) in images.enumerated() {
            if let image = image {
                let newImageView = UIImageView(image: image)
                let xCoordinate = CGFloat(index) * imageViewWidth
                newImageView.frame = CGRect(x: xCoordinate, y: 0, width: CGFloat(imageViewWidth), height: CGFloat(imageViewHeight))
                newImageView.contentMode = .scaleAspectFit
                scrollView.addSubview(newImageView)
            }
        }
        
        photoCount = numberOfImages
        currentPage = 0
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
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: productPriceTextField.frame.maxY + 20, width: view.frame.width, height: CGFloat(commentsBrain.count * 120))
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: saveButton.frame.maxY)
        saveButton.frame = CGRect(x: saveButton.frame.minX, y: mainScrollView.contentSize.height - saveButton.frame.height, width: saveButton.frame.width, height: saveButton.frame.height)
        if commentsBrain.count == 0 {
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: productPriceTextField.frame.maxY + 20, width: view.frame.width, height: 0 * 120)
            mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: productPriceTextField.frame.maxY + 114)
            saveButton.frame = CGRect(x: saveButton.frame.minX, y: mainScrollView.contentSize.height - saveButton.frame.height, width: saveButton.frame.width, height: saveButton.frame.height)
            
            saveButton.topAnchor.constraint(equalTo: productStockTextField.bottomAnchor, constant: 16).isActive = true
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
            self.db.collection("users").document(self.user!).collection("Comments").document("Comment").collection(self.documentID).document(commentsBrain[indexPath.row].Documentid).delete()
            commentsBrain.remove(at:  indexPath.row)
            tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getCommentsData(){
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    if let comment = data["Comment"] as? String ,let date = data["Date"] as? Int , let name = data["Name"] as? String, let rate = data["Rate"] as? Double , let id = data["Documentid"] as? String{
                        let cmmnt = commentBrain(Comment: comment, Date: Double(date), Rate: Double(rate), Name: name,Documentid: id)
                        commentsBrain.append(cmmnt)
                        print("ert\(comment)")
                    }
                }
                print("ert\(commentsBrain)")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            if commentsBrain.count != 0 {
                // Add rating view
                ratingView.backgroundColor = .white
                ratingView.layer.cornerRadius = 8.0
                ratingView.layer.shadowColor = UIColor.black.cgColor
                ratingView.layer.shadowOffset = CGSize(width: 0, height: 2)
                ratingView.layer.shadowOpacity = 0.2
                ratingView.layer.shadowRadius = 2.0
                ratingView.translatesAutoresizingMaskIntoConstraints = false
                
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
                
                getAverageRateData(){
                    let averageRate = self.average
                    let ratingLabel = UILabel()
                    ratingLabel.text = String(format: "%.1f", averageRate)
                    ratingLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                    
                    ratingLabel.textColor = .darkGray
                    ratingLabel.textAlignment = .center
                    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.ratingView.addSubview(ratingLabel)
                    ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsStackView.trailingAnchor, constant: 10.0).isActive = true
                    ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsStackView.centerYAnchor).isActive = true
                    
                    for i in 1...5 {
                        let starImageView = UIImageView()
                        starImageView.tintColor = UIColor.systemYellow
                        starImageView.contentMode = .scaleAspectFit
                        starImageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        if Int(Double(i)) <= Int(averageRate) {
                            starImageView.image = filledStarImage
                        } else {
                            starImageView.image = emptyStarImage
                        }
                        
                        ratingStarsStackView.addArrangedSubview(starImageView)
                        
                        // Add constraints for the star image view
                        starImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                        starImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
                    }
                    ratingView.widthAnchor.constraint(equalToConstant: CGFloat(ratingLabel.frame.maxX + 5)).isActive = true
                }
                
                
                ratingStarsStackView.topAnchor.constraint(equalTo: ratingView.topAnchor).isActive = true
                ratingStarsStackView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor).isActive = true
                ratingStarsStackView.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor).isActive = true
            }
        }
    }
    private func getAverageRateData(completion: @escaping () -> Void) {
        var usersArray = [""]
        var rates = [0]
        usersArray = []
        rates = []
        self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).collection("Comments").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    usersArray.append(document.documentID)
                }
                for usr in usersArray {
                    self.db.collection("developer@gmail.com").document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).collection("Comments").document(usr).getDocument(source: .cache) { (document, error) in
                        if let document = document {
                            let data = document.data()
                            rates.append(data!["Rate"] as! Int)
                            if rates.count == usersArray.count {
                                self.average = Double(rates.reduce(0, +)) / Double(rates.count)
                                completion()
                            }
                        } else {
                            print("Document does not exist in cache")
                        }
                    }
                }
            }
        }
    }
    private func dissmissAndClosePickerView(){
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
    private func setupPicker(){
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
    private func setupView() {
        // Add subviews
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        contentView.addSubview(pageLabel)
        contentView.addSubview(addPhotoButton)
        contentView.addSubview(deleteImageButton)
        contentView.addSubview(productCategoryTextField)
        contentView.addSubview(productNameTextField)
        contentView.addSubview(productDetailTextView)
        contentView.addSubview(productPriceTextField)
        contentView.addSubview(productStockTextField)
        contentView.addSubview(tableView)
        contentView.addSubview(ratingView)
        contentView.addSubview(saveButton)
        
        // Configure subviews
        configureMainScrollView()
        configureContentView()
        configureScrollView()
        configurePageControl()
        configurePageLabel()
        configureAddPhotoButton()
        configureDeleteImageButton()
        configureProductCategoryTextField()
        configureProductNameTextField()
        configureProductDetailTextView()
        configureProductPriceTextField()
        configureProductStockTextField()
        configureTableView()
        configureRatingView()
        configureSaveButton()
        
        
    }
    private func configureMainScrollView() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.backgroundColor = .white
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
    }
    
    private func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
    }
    
    private func configurePageLabel() {
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.font = UIFont.systemFont(ofSize: 16)
        pageLabel.textColor = .black
    }
    
    private func configureAddPhotoButton() {
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.setTitle("Fotoğraf ekle", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    private func configureDeleteImageButton() {
        deleteImageButton.translatesAutoresizingMaskIntoConstraints = false
        deleteImageButton.setTitle("Fotoğrafı sil", for: .normal)
        deleteImageButton.setTitleColor(.systemRed, for: .normal)
        deleteImageButton.addTarget(self, action: #selector(deleteImageButtonTapped), for: .touchUpInside)
    }
    
    private func configureProductCategoryTextField() {
        productCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        productCategoryTextField.placeholder = "Ürün kategorisini girin"
        productCategoryTextField.borderStyle = .roundedRect
    }
    
    private func configureProductNameTextField() {
        productNameTextField.translatesAutoresizingMaskIntoConstraints = false
        productNameTextField.placeholder = "Ürün ismini girin"
        productNameTextField.borderStyle = .roundedRect
    }
    
    private func configureProductDetailTextView() {
        productDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        productDetailTextView.textAlignment = .left
        productDetailTextView.isScrollEnabled = true
        productDetailTextView.layer.borderColor = UIColor.lightGray.cgColor
        productDetailTextView.font = UIFont.systemFont(ofSize: 14)
        productDetailTextView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        productDetailTextView.layer.borderWidth = 1.0
        productDetailTextView.layer.cornerRadius = 5.0
        productDetailTextView.text = "Ürün detaylarını girin"
    }
    
    private func configureProductPriceTextField() {
        productPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        productPriceTextField.placeholder = "Ürün fiyatını girin"
        productPriceTextField.borderStyle = .roundedRect
        productPriceTextField.keyboardType = .decimalPad
    }
    
    private func configureProductStockTextField() {
        productStockTextField.translatesAutoresizingMaskIntoConstraints = false
        productStockTextField.placeholder = "Ürün stoğunu Girin"
        productStockTextField.borderStyle = .roundedRect
        productStockTextField.keyboardType = .numberPad
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        tableView.register(ProductReviewTableViewCell.self, forCellReuseIdentifier: "productReviewCell")
    }
    
    private func configureRatingView() {
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        // Configure ratingView with a custom rating component or library
    }
    
    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Değişiklikleri kaydet", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 5.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        // Main ScrollView Constraints
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Content View Constraints
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
        
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 60),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -60),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            scrollView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.height / 4))
        ])
        
        // Page Control Constraints
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: -5),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Page Label Constraints
        NSLayoutConstraint.activate([
            pageLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            pageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Add Photo Button Constraints
        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalTo: pageLabel.bottomAnchor),
            addPhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Delete Image Button Constraints
        NSLayoutConstraint.activate([
            deleteImageButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor,constant: 5),
            deleteImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Product Category TextField Constraints
        NSLayoutConstraint.activate([
            productCategoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productCategoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productCategoryTextField.topAnchor.constraint(equalTo: deleteImageButton.bottomAnchor,constant: 5),
            productCategoryTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Product Name TextField Constraints
        NSLayoutConstraint.activate([
            productNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productNameTextField.topAnchor.constraint(equalTo: productCategoryTextField.bottomAnchor, constant: 8),
            productNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Product Detail TextView Constraints
        NSLayoutConstraint.activate([
            productDetailTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productDetailTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productDetailTextView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: 8),
            productDetailTextView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.height * 0.15))
        ])
        
        // Product Price TextField Constraints
        NSLayoutConstraint.activate([
            productPriceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productPriceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productPriceTextField.topAnchor.constraint(equalTo: productDetailTextView.bottomAnchor, constant: 8),
            productPriceTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Product Stock TextField Constraints
        NSLayoutConstraint.activate([
            productStockTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productStockTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productStockTextField.topAnchor.constraint(equalTo: productPriceTextField.bottomAnchor, constant: 8),
            productStockTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // TableView Constraints
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: productStockTextField.bottomAnchor, constant: 8),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Rating View Constraints
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            ratingView.widthAnchor.constraint(equalToConstant: CGFloat(view.frame.height * 0.3)),
            ratingView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Save Button Constraints
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func viewDidLoadSettings(){
        imgPicker.sourceType = .photoLibrary
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        productNameTextField.text = collectionViewData[selectedItem].productName
        productPriceTextField.text = collectionViewData[selectedItem].productPrice
        productDetailTextView.text = collectionViewData[selectedItem].productDetail
        productCategoryTextField.text = collectionViewData[selectedItem].productCategory
        
        self.db.collection("developer@gmail.com").document("Stock").collection("Stock").document(collectionViewData[selectedItem].productName).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let stock = data!["\(collectionViewData[selectedItem].productName)"] as! Int
                self.productStockTextField.text = "\(stock)"
            } else {
                print("Document does not exist")
            }
        }
    }
    @objc func saveButtonTapped(){
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
                print("file deleted")
            }
        }
        images5Ref.delete { error in
            if let error = error {
                print(error)
            } else {
                print("file deleted")
            }
        }
        images4Ref.delete { error in
            if let error = error {
                print(error)
            } else {
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
        if let name = productNameTextField.text, let price = productPriceTextField.text, let detail = productDetailTextView.text, let category = productCategoryTextField.text , let stock = productStockTextField.text {
            //Delete old informations
            let shouldDelete = db.collection(user!).document("Products").collection(firstCategory).document(documentID)
            shouldDelete.delete()
            
            // Update the product information
            db.collection(user!).document("Products").collection(category).document(name).setData([
                "name": name,
                "price": price,
                "detail": detail,
                "averageRate": average,
                "timestamp": Date().timeIntervalSince1970
            ], merge: true) { error in
                if let error = error {
                    print("Error updating product information: \(error.localizedDescription)")
                    // Display an error message if the update failed
                    let alert = UIAlertController(title: "Error", message: "Failed to update product information.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Stok durumunu güncelle.
                    self.db.collection("developer@gmail.com").document("Stock").collection("Stock").document(name).setData([name:Int(stock)!])
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
    @objc func deleteImageButtonTapped(){
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
    @objc func addPhotoButtonTapped(){
        if photoCount == 3 {
            let alert = UIAlertController(title: "Uyarı!", message: "Maksimum 3 fotoğraf ekleyebilirsin.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Tamam", style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            present(imgPicker, animated: true, completion: nil)
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
            // Ürünün stoğunu silme
            self.db.collection("developer@gmail.com").document("Stock").collection("Stock").document(collectionViewData[selectedItem].productName).delete()
            
            // Ürünü adet olarak databaseden düşme
            self.db.collection("developer@gmail.com").document("numberofitems").getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let numberofcategory = data!["category"] as! Int
                    let numberofproduct = data!["product"] as! Int
                    
                    self.db.collection("developer@gmail.com").document("numberofitems").setData(["category" : numberofcategory , "product": numberofproduct - 1])
                } else {
                    print("Document does not exist")
                }
            }
            //Kullanıcıların Coredatasından silme
            self.db.collection("developer@gmail.com").document("productDeletedByTheDeveloper").collection("Deleted").document(self.documentID).setData(["Deleted" : "Deleted"])
            // Delete from Database
            self.db.collection(self.user!).document("Products").collection(collectionViewData[selectedItem].productCategory).document(self.documentID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            // Databasedeki Listed'den çıkarma
            self.db.collection("developer@gmail.com").document("Listed-Non Listed Products").collection("ListedProducts").document(self.documentID).delete()
            
            self.db.collection("users").document(self.user!).collection("Comments").document("Comment").collection(self.documentID).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.db.collection("users").document(self.user!).collection("Comments").document("Comment").collection(self.documentID).document(document.documentID).delete()
                    }
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
