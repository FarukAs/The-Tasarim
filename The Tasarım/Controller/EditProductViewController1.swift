
import UIKit

class EditProductViewController1: UIViewController {

    var selectedItem = 1000
    
    var productName = ""
    var productPrice = ""
    var productCategory = ""
    var productDetail = ""
    var image1 = UIImage(named: "logo")
    var image2 = UIImage(named: "logo")
    var image3 = UIImage(named: "logo")
    
    @IBOutlet var deleteImageButton3: UIButton!
    @IBOutlet var deleteImageButton2: UIButton!
    @IBOutlet var deleteImageButton1: UIButton!
    @IBOutlet var productPriceTextField: UITextField!
    @IBOutlet var productDetailTextView: UITextView!
    @IBOutlet var productCategoryTextField: UITextField!
    @IBOutlet var productNameTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productNameTextField.text = collectionViewData[selectedItem].productName
        productPriceTextField.text = collectionViewData[selectedItem].productPrice
        productDetailTextView.text = collectionViewData[selectedItem].productDetail
        productCategoryTextField.text = collectionViewData[selectedItem].productCategory
        
        image1 = collectionViewData[selectedItem].image1
        image2 = collectionViewData[selectedItem].image2
        image3 = collectionViewData[selectedItem].image3
        
        var photoCount = 0
        
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
        
        if let image1 = image1 {
            let newImageView1 = UIImageView(image: image1)
            newImageView1.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            scrollView.addSubview(newImageView1)
            xCoordinate += imageViewWidth
        }
        
        if let image2 = image2 {
            let newImageView2 = UIImageView(image: image2)
            newImageView2.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            scrollView.addSubview(newImageView2)
            xCoordinate += imageViewWidth
        }
        
        if let image3 = image3 {
            let newImageView3 = UIImageView(image: image3)
            newImageView3.frame = CGRect(x: xCoordinate, y: 0, width: imageViewWidth, height: imageViewHeight)
            scrollView.addSubview(newImageView3)
        }
    }
    
    @IBAction func deleteImage3(_ sender: UIButton) {
    }
    @IBAction func deleteImage2(_ sender: UIButton) {
    }
    @IBAction func deleteImage1(_ sender: UIButton) {
    }
}
