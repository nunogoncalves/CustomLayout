//
//  TextCell.swift
//  CustomLayout
//
//  Created by Nuno Castro  on 29/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TextCell : UICollectionViewCell {

    static let sharedInstance = TextCell(frame: .zero)

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    var hero: Hero? {
        didSet {
            configure(with: hero!)
        }
    }

    var imageViewWConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(label)

//        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
//        imageViewWConstraint = imageView.widthAnchor.constraint(equalTo: widthAnchor)
//        imageViewWConstraint.isActive = true
//
//        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3).isActive = true
//
//        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageLoader = Cache.ImageLoader.shared

    func configure(with hero: Hero) {

        label.text = hero.description

        if let image = imageLoader.cachedImage(with: hero.imageURL) {
            imageView.image = image
        } else {
            imageLoader.image(with: hero.imageURL) { [weak self] image in
                self?.imageView.image = image
            }
        }

        let textHeight = (hero.description ?? "").heightWithConstrainedWidth(self.frame.width, font: label.font)

        let imageFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width * 1.33)
        let labelFrame = CGRect(x: 0, y: imageFrame.maxY, width: self.frame.width, height: textHeight)

        imageView.frame = imageFrame
        label.frame = labelFrame
    }

    var minimumHeight: CGFloat {
        return label.frame.maxY
    }


}

extension String {

    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {

        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let string = NSString(string: self)
        var boundingBox = string.boundingRect(with: constraintRect,
                                              options: .usesLineFragmentOrigin,
                                              attributes: [NSAttributedStringKey.font: font],
                                              context: nil)


        string.boundingRect(with: constraintRect,
                            options: [],
                            attributes: [NSAttributedStringKey.font: font], context: nil)

        boundingBox.size.height = CGFloat(roundf(Float(boundingBox.height + CGFloat(1.0))))

        return boundingBox.height
    }
}
