//
//  FeedbackTableViewCell.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 16.03.2023.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    static let identifier = "FeedbackTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(userImageView)
        addSubview(userEmailLabel)
        addSubview(feedbackDateLabel)
        addSubview(feedbackTextLabel)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60),
            
            userEmailLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userEmailLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            
            feedbackDateLabel.leadingAnchor.constraint(equalTo: userEmailLabel.trailingAnchor, constant: 8),
            feedbackDateLabel.firstBaselineAnchor.constraint(equalTo: userEmailLabel.firstBaselineAnchor),
            
            feedbackTextLabel.leadingAnchor.constraint(equalTo: userEmailLabel.leadingAnchor),
            feedbackTextLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 8),
            feedbackTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            feedbackTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with feedback: Feedback) {
        if let imgg = feedback.imageData.jpegData(compressionQuality: 1.0){
            userImageView.image = UIImage(data: imgg)
        }
        userEmailLabel.text = feedback.userEmail
        feedbackDateLabel.text = formatDate(from: feedback.timestamp)
        feedbackTextLabel.text = feedback.text
    }
    
    private func formatDate(from timestamp: Date) -> String {
        // Tarih biçimlendirici nesnesi oluşturuluyor.
        let dateFormatter = DateFormatter()
        // Tarih ve saat stilleri ayarlanıyor.
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // Tarih biçimlendirici, zaman damgasından okunabilir bir tarih ve saat stringi oluşturur.
        let formattedDate = dateFormatter.string(from: timestamp)
        
        return formattedDate
    }
}
