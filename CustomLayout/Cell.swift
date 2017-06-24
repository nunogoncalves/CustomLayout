//
//  Cell.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

public class Cell : UICollectionViewCell {
    
    let label = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.backgroundColor = .purple
        label.numberOfLines = 0
        contentView.backgroundColor = .green
        label.textColor = .white
        
        label.font = UIFont.systemFont(ofSize: 25)
        label.pinToEdges(of: contentView, top: 2, leading: 10, bottom: -2, trailing: -10)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        layoutIfNeeded()
        
        let size = CGSize(width: layoutAttributes.frame.width,
                          height: UILayoutFittingCompressedSize.height)
        let preferredSize = systemLayoutSizeFitting(
            size,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .fittingSizeLevel)
        
        preferredAttributes.frame.size = CGSize(width: layoutAttributes.frame.width,
                                                height: preferredSize.height)
        return preferredAttributes
    }
    
}

