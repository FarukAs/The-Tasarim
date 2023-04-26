import UIKit

class ProductReviewTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    let nameLabel = UILabel()
    let ratingView = UIView()
    let commentLabel = UILabel()
    let dateLabel = UILabel()
    
    // Date formatter
    let dateFormatter = DateFormatter()
    
    //MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Add rating view
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingView)
        
        // Add comment label
        commentLabel.numberOfLines = 0
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(commentLabel)
        
        // Add date label
        dateLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateLabel.textColor = UIColor.gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        // Set date formatter style
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // Set constraints
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            ratingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            ratingView.heightAnchor.constraint(equalToConstant: 20.0),
            ratingView.widthAnchor.constraint(equalToConstant: 120.0),
            
            commentLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8.0),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            commentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 8.0),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Methods
    
    func configure(name: String, rating: Double, comment: String, date: Date) {
        nameLabel.text = name
        commentLabel.text = comment
        
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
            
            if Double(i) <= rating {
                starImageView.image = filledStarImage
            } else {
                starImageView.image = emptyStarImage
            }
            
            ratingStarsStackView.addArrangedSubview(starImageView)
            
            // Add constraints for the star image view
            starImageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        }
        
        // Add constraints for the rating stars stack view
        ratingStarsStackView.topAnchor.constraint(equalTo: ratingView.topAnchor).isActive = true
        ratingStarsStackView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor).isActive = true
        ratingStarsStackView.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor).isActive = true
        ratingStarsStackView.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor).isActive = true
        
        // Set the review date
        dateLabel.text = dateFormatter.string(from: date)
    }
}
