//
//  FullScreenImageViewViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 23.03.2023.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    var image: UIImage?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.image = image
        setupConstraints()
        addTapGesture()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeFullScreen))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func closeFullScreen() {
        dismiss(animated: true, completion: nil)
    }
}
