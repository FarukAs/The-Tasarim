//
//  AccountViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
class AccountViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var devView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var topView: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userInfo: UILabel!
    @IBOutlet var profile: UIButton!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    
    
    var gradientLayer: CAGradientLayer!
    var currentGradient = 0
    var gradientColors: [[CGColor]] = [
        [UIColor(red: 0.973, green: 0.769, blue: 0.345, alpha: 1.0).cgColor, UIColor(red: 1.000, green: 0.498, blue: 0.314, alpha: 1.0).cgColor],
        [UIColor(red: 0.933, green: 0.137, blue: 0.161, alpha: 1.0).cgColor, UIColor(red: 0.667, green: 0.224, blue: 0.478, alpha: 1.0).cgColor],
        [UIColor(red: 0.224, green: 0.722, blue: 0.906, alpha: 1.0).cgColor, UIColor(red: 0.086, green: 0.329, blue: 0.973, alpha: 1.0).cgColor],
        [UIColor(red: 0.906, green: 0.902, blue: 0.133, alpha: 1.0).cgColor, UIColor(red: 0.902, green: 0.557, blue: 0.098, alpha: 1.0).cgColor],
        [UIColor(red: 0.973, green: 0.769, blue: 0.345, alpha: 1.0).cgColor, UIColor(red: 1.000, green: 0.498, blue: 0.314, alpha: 1.0).cgColor],
        [UIColor(red: 0.933, green: 0.137, blue: 0.161, alpha: 1.0).cgColor, UIColor(red: 0.667, green: 0.224, blue: 0.478, alpha: 1.0).cgColor],
        [UIColor(red: 0.224, green: 0.722, blue: 0.906, alpha: 1.0).cgColor, UIColor(red: 0.086, green: 0.329, blue: 0.973, alpha: 1.0).cgColor],
        [UIColor(red: 0.906, green: 0.902, blue: 0.133, alpha: 1.0).cgColor, UIColor(red: 0.902, green: 0.557, blue: 0.098, alpha: 1.0).cgColor],
        [UIColor(red: 0.973, green: 0.769, blue: 0.345, alpha: 1.0).cgColor, UIColor(red: 1.000, green: 0.498, blue: 0.314, alpha: 1.0).cgColor],
        [UIColor(red: 0.933, green: 0.137, blue: 0.161, alpha: 1.0).cgColor, UIColor(red: 0.667, green: 0.224, blue: 0.478, alpha: 1.0).cgColor],
        [UIColor(red: 0.224, green: 0.722, blue: 0.906, alpha: 1.0).cgColor, UIColor(red: 0.086, green: 0.329, blue: 0.973, alpha: 1.0).cgColor],
        [UIColor(red: 0.906, green: 0.902, blue: 0.133, alpha: 1.0).cgColor, UIColor(red: 0.902, green: 0.557, blue: 0.098, alpha: 1.0).cgColor],
        [UIColor(red: 0.973, green: 0.769, blue: 0.345, alpha: 1.0).cgColor, UIColor(red: 1.000, green: 0.498, blue: 0.314, alpha: 1.0).cgColor],
        [UIColor(red: 0.933, green: 0.137, blue: 0.161, alpha: 1.0).cgColor, UIColor(red: 0.667, green: 0.224, blue: 0.478, alpha: 1.0).cgColor],
        [UIColor(red: 0.224, green: 0.722, blue: 0.906, alpha: 1.0).cgColor, UIColor(red: 0.086, green: 0.329, blue: 0.973, alpha: 1.0).cgColor],
        [UIColor(red: 0.906, green: 0.902, blue: 0.133, alpha: 1.0).cgColor, UIColor(red: 0.902, green: 0.557, blue: 0.098, alpha: 1.0).cgColor]
    ]
    var urlimage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        profile.layer.cornerRadius = 0.5 * profile.bounds.size.width
        profile.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        navigationItem.title = "Hesabım"
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = topView.bounds
        gradientLayer.colors = gradientColors[currentGradient]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        topView.layer.addSublayer(gradientLayer)
        animateGradient()
        coupon = []
        getCouponData()
        getNumberOfCoupons()
        stackView.layer.zPosition = 1
        button.layer.cornerRadius = 10
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dev))
        topView.addGestureRecognizer(tapGestureRecognizer)
        
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        navigationItem.rightBarButtonItem = bellButton
        
        let docRef = db.collection("users").document(user!).collection("userInfo").document("Info")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let user = UserInfo(name: data!["name"] as! String,
                                    surname: data!["surname"] as! String,
                                    phoneNumber: data!["phoneNumber"] as! String,
                                    email: data!["email"] as! String)
                td_currentuser = UserDefaultsKeys(givenName: user.name, familyName: user.surname, email: user.email, phoneNumber: user.phoneNumber)

                    let firstLetter = String(user.name.prefix(1))
                    let secondLetter = String(user.surname.prefix(1))
                    let currentAttributes = self.profile.titleLabel?.attributedText?.attributes(at: 0, effectiveRange: nil)
                    let attributedTitle = NSAttributedString(string: "\(firstLetter)\(secondLetter)", attributes: currentAttributes)

                    self.profile.setAttributedTitle(attributedTitle, for: .normal)
                    self.userInfo.text = "\(user.name) \(user.surname)"
         
            } else {
                print("Document does not exist")
            }
        }
    }
    @objc func dev() {
        if user == "developer@gmail.com" {
            performSegue(withIdentifier: "accountToDeveloper", sender: nil)
        }
        
    }
    @objc func bellButtonTapped() {
        print("bellbuttontapped")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "TableViewCell" , for: indexPath) as! TableViewCell?)!
        cell.label.text = AccountMenu[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountMenu.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.item
        if selectedRow == 2 {
            performSegue(withIdentifier: "accountToAdress", sender: nil)
        }
        if selectedRow == 3 {
            performSegue(withIdentifier: "accountToCoupon", sender: nil)
        }
        if selectedRow == 4 {
            performSegue(withIdentifier: "accountToGame", sender: nil)
        }
        //Hesabım
        if selectedRow == 5 {
            performSegue(withIdentifier: "accountToMyAccount", sender: nil)
        }
        
        if selectedRow == 6 {
            performSegue(withIdentifier: "accountToFeedBack", sender: nil)
        }
        if selectedRow == 7 {
            do {
                try Auth.auth().signOut()
                self.navigateToLoginViewController()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    func animateGradient() {
        currentGradient = (currentGradient + 1) % gradientColors.count
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 3.0
        animation.fromValue = gradientLayer.colors
        animation.toValue = gradientColors[currentGradient]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        gradientLayer.add(animation, forKey: "gradientChange")
    }
    func getCouponData(){
        db.collection("users").document(user!).collection("Coupons").document("CouponsData").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    let data = document.data()
                let safeData = Coupons(category: data!["category"] as! String, limit: data!["limit"] as! String, price: data!["price"] as! String)
                    coupon.append(safeData)
            } else {
                print("Document does not exist")
            }
        }
        
    }
    func getNumberOfCoupons(){
        let docRef = db.collection("users").document(user!).collection("Coupons").document("NumberOfCoupons")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let safeData = data!["number"] as! Int
                numberOfData = safeData
                print("işit\(numberOfData)")
            } else {
                print("Document does not exist")
            }
        }
    }
    func showLoader() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Yükleniyor..."
    }
    func hideLoader() {
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        MBProgressHUD.hide(for: view, animated: true)
    }
    func navigateToLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("Navigation controller not found")
        }
    }
}

