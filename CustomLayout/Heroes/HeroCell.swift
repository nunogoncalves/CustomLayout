//
//  HeroCell.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    let imageLoader = Cache.ImageLoader.shared
    
    var heroTuple: (hero: Hero, i: Int)? {
        didSet {
            guard let hero = heroTuple?.hero, let i = heroTuple?.i else { return prepareForReuse() }
            
            heroImageView.image = nil
            heroNameLabel.text = "\(i) - \(hero.name)"
            heroDescriptionLabel.text = hero.description
            
            if let image = imageLoader.cachedImage(with: hero.imageURL) {
                heroImageView.image = image
            } else {
                imageLoader.image(with: hero.imageURL) { [weak self] image in
                    self?.heroImageView.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.image = nil
        heroNameLabel.text = nil
        heroDescriptionLabel.text = nil
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        layoutIfNeeded()

        let size = CGSize(width: layoutAttributes.frame.width,
                          height: UILayoutFittingCompressedSize.height)
        let preferredSize = systemLayoutSizeFitting(size,
                                                    withHorizontalFittingPriority: .defaultHigh,
                                                    verticalFittingPriority: .fittingSizeLevel)
        
        preferredAttributes.frame.size = CGSize(width: layoutAttributes.frame.width,
                                                height: preferredSize.height)
        return preferredAttributes
    }
}