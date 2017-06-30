//
//  HeroCell.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class Hero2Cell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.backgroundColor = .orange
        return imageView
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
//        stackView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(750), for: .vertical)
//        label.setContentCompressionResistancePriority(UILayoutPriority(750), for: .vertical)
//        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(750), for: .vertical)
//        label.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
//        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imageLoader = Cache.ImageLoader.shared

    let imageWConstraint: NSLayoutConstraint

    override init(frame: CGRect) {


        imageWConstraint = imageView.widthAnchor.constraint(equalToConstant: 161)

        super.init(frame: frame)

        print(frame)
        addSubview(imageView)
        addSubview(stackView)


        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        let label = UILabel()
        stackView.addArrangedSubview(label)

        stackView.addSubview(nameLabel)
        stackView.addSubview(descriptionLabel)
        stackView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 161),
            imageView.heightAnchor.constraint(equalToConstant: 214),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageWConstraint,

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var heroTuple: (hero: Hero, i: Int)? {
        didSet {
            guard let hero = heroTuple?.hero, let i = heroTuple?.i else { return prepareForReuse() }
            
            nameLabel.text = "\(i) - \(hero.name)"
            descriptionLabel.text = hero.description
            imageView.image = #imageLiteral(resourceName: "hero")
//            if let image = imageLoader.cachedImage(with: hero.imageURL) {
//                imageView.image = image
//            } else {
//                imageLoader.image(with: hero.imageURL) { [weak self] image in
//                    self?.imageView.image = image
//                }
//            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

//        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        let preferredAttributes = layoutAttributes

//           = layoutAttributes.frame.width
//        setNeedsLayout()
//        layoutIfNeeded()

        let size = CGSize(width: layoutAttributes.frame.width,
                          height: UILayoutFittingCompressedSize.height)

//        let preferredSize = systemLayoutSizeFitting(size,
//                                                    withHorizontalFittingPriority: .defaultHigh,
//                                                    verticalFittingPriority: .fittingSizeLevel)

        let stackViewPreferredSize = stackView.systemLayoutSizeFitting(size,
                                                                       withHorizontalFittingPriority: .defaultHigh,
                                                                       verticalFittingPriority: .fittingSizeLevel)

        let height = stackViewPreferredSize.height + (layoutAttributes.frame.width * 1.33) + 5
        layoutAttributes.frame.size = CGSize(width: layoutAttributes.frame.width, height: height)
        return layoutAttributes
    }
}
