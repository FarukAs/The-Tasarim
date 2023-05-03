//
//  QuestionAnswerDetailsViewController.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 23.04.2023.
//

import UIKit
import Lottie

class QuestionAnswerDetailsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private var askQuestionViewBottomConstraint: NSLayoutConstraint!
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionAnswerDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "QuestionAnswerCell")
        return collectionView
    }()
    private let askQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Mağazaya Soru Sor", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(askQuestionButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var askQuestionView: AskQuestionView = {
        let view = AskQuestionView()
        view.parentViewController = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // Soru cevap yoksa
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "danceAnimation")
        animation.loopMode = .loop
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Henüz bu ürüne soru sorulmadı"
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 20)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    private let minimumCellHeight: CGFloat = 120.0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Soru-Cevap"
        view.addSubview(collectionView)
        view.addSubview(askQuestionButton)
        view.addSubview(askQuestionView)
        setupAskQuestionView()
        setupConstraints()
        setupCollectionView()
        askQuestionView.closeAction = {
            UIView.animate(withDuration: 0.3) {
                self.askQuestionViewBottomConstraint.constant = 390
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.askQuestionView.isHidden = true
                self.emptyStateView.isHidden = false
            }
        }
        if questionAnswerData.count == 0 {
            view.addSubview(emptyStateView)
            emptyStateView.addSubview(animationView)
            emptyStateView.addSubview(emptyStateLabel)
            setupEmptyStateView()
            emptyStateView.isHidden = false
            animationView.play()
            emptyStateView.layer.zPosition = -1
            askQuestionView.layer.zPosition = 9
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func setupEmptyStateView() {
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: askQuestionButton.topAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            
            emptyStateLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -16)
        ])
    }

    @objc private func askQuestionButtonTapped() {
        print("Mağazaya Soru Sor butonuna tıklandı.")
        askQuestionView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.askQuestionViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        emptyStateView.isHidden = true
    }
    private func setupAskQuestionView() {
        askQuestionViewBottomConstraint = askQuestionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 390)
        
        NSLayoutConstraint.activate([
            askQuestionView.topAnchor.constraint(equalTo: view.topAnchor),
            askQuestionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            askQuestionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            askQuestionViewBottomConstraint
        ])
    }
    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: askQuestionButton.topAnchor, constant: -4),
            
            askQuestionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            askQuestionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            askQuestionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            askQuestionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if questionAnswerData.count != 0 {
            return questionAnswerData.count
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if questionAnswerData.count != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerDetailsCollectionViewCell
            cell.configure(with: questionAnswerData[indexPath.item])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerDetailsCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if questionAnswerData.count != 0 {
            let product = questionAnswerData[indexPath.item]
            let approximateWidth = collectionView.frame.width - 40
            let textSize = CGSize(width: approximateWidth, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let answerSize = NSString(string: product.answer).boundingRect(with: textSize, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            let questionSize = NSString(string: product.question).boundingRect(with: textSize, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            let askerSize = NSString(string: product.askerName).boundingRect(with: textSize, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            let sellerSize = NSString(string: product.sellerName).boundingRect(with: textSize, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            let estimatedHeight = answerSize.height + questionSize.height + askerSize
                .height + sellerSize.height + 22
            
            return CGSize(width: collectionView.frame.width, height: estimatedHeight)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.askQuestionView.frame.origin.y == 0 {
                self.askQuestionView.frame.origin.y -= keyboardSize.height
                emptyStateView.isHidden = true
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.askQuestionView.frame.origin.y != 0 {
            self.askQuestionView.frame.origin.y = 0
        }
    }
}

