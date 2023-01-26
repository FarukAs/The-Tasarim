//
//  AccountViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet var profile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        profile.layer.cornerRadius = 0.5 * profile.bounds.size.width
        profile.clipsToBounds = true
        
    }
    

}
