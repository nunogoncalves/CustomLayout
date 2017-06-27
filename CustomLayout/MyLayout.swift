//
//  MyLayout.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class MyLayout : UICollectionViewLayout, CustomLayout {

    typealias InvalidationContext = UICollectionViewLayoutInvalidationContext
    typealias LayoutAttributes = UICollectionViewLayoutAttributes

    private lazy var calculator: LayoutCalculator = {
        return LayoutCalculator(layout: self)
    }()
    
    private (set) var itemsPerRow: Int
    
    lazy var xBetweenColumns: CGFloat = 5
    let yBetweenRows: CGFloat = 5

    var estimatedHeight: CGFloat = 300

    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var totalWidth: CGFloat {
        guard let cv = collectionView else { return 0 }
        return cv.bounds.width - (cv.contentInset.left + cv.contentInset.right)
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
        let height = calculator.totalHeight
        let size = CGSize(width: totalWidth, height: height)
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [LayoutAttributes]? {
        
        let layoutAttributes: [LayoutAttributes] = (0..<numberOfItems).flatMap {
            let indexPath = IndexPath(item: $0, section: 0)
            
            let frame = self.calculator.frame(for: indexPath)
            if !frame.intersects(rect) {
                return nil
            }
            
            return self.layoutAttributesForItem(at: indexPath)
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
        
        let attributes = LayoutAttributes(forCellWith: indexPath)
        attributes.frame = calculator.frame(for: indexPath)
        
        return attributes
    }
    
    override func shouldInvalidateLayout(
        forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
        withOriginalAttributes originalAttributes: LayoutAttributes) -> Bool
    {
        
        let pref = preferredAttributes
        let orig = originalAttributes

        print("pref", pref.frame.height, "origin", orig.frame.height)

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
    
    override func invalidationContext(
        forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
        withOriginalAttributes originalAttributes: LayoutAttributes) -> InvalidationContext
    {
        
        let pref = preferredAttributes
        let orig = originalAttributes
        let indexItem = orig.indexPath.item
        
        let context = super.invalidationContext(forPreferredLayoutAttributes: pref, withOriginalAttributes: orig)
        
        let oldContentSize = collectionViewContentSize
        let newContentSize = collectionViewContentSize
        
        calculator.indexHeights[indexItem] = calculator.maxHeightsForRows[calculator.row(for: indexItem)] ?? pref.size.height
        
        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)

        //invalidate layout for complete current row and everything afterwards.
        invalidateLayout(atRow: calculator.row(for: indexItem), using: context)
        invalidateLayout(after: originalAttributes.indexPath, using: context)
        
        return context
    }
    
    private func invalidateLayout(after indexPath: IndexPath, using context: InvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(after: indexPath))
    }
    
    private func invalidateLayout(atRow row: Int, using context: InvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(forRow: row))
    }
}
