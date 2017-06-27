//
//  MyLayout.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

public class MyLayout : UICollectionViewLayout, CustomLayout {
    
    private lazy var calculator: LayoutCalculator = {
        return LayoutCalculator(layout: self)
    }()
    
    private (set) var itemsPerRow: Int
    
    lazy var xBetweenColumns: CGFloat = 0
    let yBetweenRows: CGFloat = 5
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var totalWidth: CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    public init(itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow > 0 ? itemsPerRow : 1
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func updateItemsPerRow(to itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow
        calculator.reset()
        invalidateLayout()
    }
    
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let width = collectionView.bounds.width
        let height = calculator.totalHeight
        let size = CGSize(width: width, height: height)
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes: [UICollectionViewLayoutAttributes] = (0..<numberOfItems).flatMap {
            let indexPath = IndexPath(item: $0, section: 0)
            
            let frame = self.calculator.frame(for: indexPath)
            if !frame.intersects(rect) {
                return nil
            }
            
            return self.layoutAttributesForItem(at: indexPath)
        }
        
        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = calculator.frame(for: indexPath)
        
        return attributes
    }
    
    public override func shouldInvalidateLayout(
        forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool
    {
        
        let pref = preferredAttributes
        let orig = originalAttributes
        
        if pref.frame.height == orig.frame.height {
            return false
        }
        
        let index = pref.indexPath.item
        let row = calculator.row(for: index)
        
        let isLastColumn = calculator.isInLastColumn(index: index)
        
        if isLastColumn && calculator.maxHeightsForRows[row] == nil {
            return false
        }
        
        calculator.maxHeightsForRows[row] = max(calculator.maxHeightsForRows[row] ?? 0, pref.frame.height)
        
        if calculator.indexHeights[index] == calculator.maxHeightsForRows[row] { return false }
        
        calculator.indexHeights[index] = calculator.maxHeightsForRows[row]
        return isLastColumn
    }
    
    public override func invalidationContext(
        forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext
    {
        
        let pref = preferredAttributes
        let orig = originalAttributes
        
        let context = super.invalidationContext(forPreferredLayoutAttributes: pref, withOriginalAttributes: orig)
        
        let oldContentSize = collectionViewContentSize
        let newContentSize = collectionViewContentSize
        
        print(pref.frame.height)
        calculator.indexHeights[orig.indexPath.item] = calculator.maxHeightsForRows[calculator.row(for: orig.indexPath.item)] ?? pref.size.height
        
        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)
        
        invalidateLayout(atRow: calculator.row(for: orig.indexPath.item), using: context)
        invalidateLayout(after: originalAttributes.indexPath, using: context)
        
        return context
    }
    
    private func invalidateLayout(after indexPath: IndexPath, using context: UICollectionViewLayoutInvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(after: indexPath))
    }
    
    private func invalidateLayout(atRow row: Int, using context: UICollectionViewLayoutInvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(forRow: row))
    }
}
