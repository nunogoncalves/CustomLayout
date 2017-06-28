//
//  MyLayout.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

final class MyLayout : UICollectionViewLayout, CustomLayout {
    
    typealias InvalidationContext = UICollectionViewLayoutInvalidationContext
    typealias LayoutAttributes = UICollectionViewLayoutAttributes

    private lazy var calculator: LayoutCalculator = {
        return LayoutCalculator(layout: self)
    }()
    
    private (set) var itemsPerRow: Int

    var layoutAttributesForIndex: [Int: MyLayoutAttributes] = [:]

    var xInset: CGFloat = 24
    lazy var xBetweenColumns: CGFloat = 5
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
        layoutAttributesForIndex = [:]
        invalidateLayout()
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let width = collectionView.bounds.width
        let height = calculator.totalHeight
        let size = CGSize(width: width, height: height)
        return size
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [LayoutAttributes]? {
        let layoutAttributes: [LayoutAttributes] = (0..<numberOfItems).flatMap {
            let indexPath = IndexPath(item: $0, section: 0)

            let frame = calculator.frame(for: indexPath)
            if !frame.intersects(rect) {
                return nil
            }

            return self.layoutAttributesForItem(at: indexPath)
        }

        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
        let attributes: MyLayoutAttributes

        if let attrs = layoutAttributesForIndex[indexPath.item] {
            attributes = attrs
        } else {
            attributes = MyLayoutAttributes(forCellWith: indexPath)
            layoutAttributesForIndex[indexPath.item] = attributes
        }

        attributes.frame = calculator.frame(for: indexPath)

        attributes.shouldIgnore = calculator.indexHeights[indexPath.item] != nil

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return (newBounds.width, newBounds.height) != (collectionView!.bounds.width, collectionView!.bounds.height)
    }
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
                                                withOriginalAttributes originalAttributes: LayoutAttributes) -> Bool {

        let pref = preferredAttributes

        if pref.frame.height == originalAttributes.frame.height {
            return false
        }

        let index = pref.indexPath.item
        let row = calculator.row(for: index)

        let isLastColumn = calculator.isInLastColumn(index: index)
        
        calculator.maxHeightsForRows[row] = max(calculator.maxHeightsForRows[row] ?? 0, pref.frame.height)

        if calculator.indexHeights[index] == calculator.maxHeightsForRows[row] {
            return false
        }
        
        calculator.indexHeights[index] = calculator.maxHeightsForRows[row]
        return isLastColumn
    }

    public override func invalidationContext(
        forPreferredLayoutAttributes preferredAttributes: LayoutAttributes,
        withOriginalAttributes originalAttributes: LayoutAttributes) -> InvalidationContext
    {
        let pref = preferredAttributes
        let orig = originalAttributes
        
        let context = super.invalidationContext(forPreferredLayoutAttributes: pref, withOriginalAttributes: orig)
        
        let oldContentSize = collectionViewContentSize

        let row = calculator.row(for: orig.indexPath.item)
        calculator.indexHeights[orig.indexPath.item] = calculator.maxHeightsForRows[row] ?? pref.size.height

        let newContentSize = collectionViewContentSize

        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)
        
        invalidateLayout(atRow: row, using: context)
        invalidateLayout(after: originalAttributes.indexPath, using: context)
        
        return context
    }
    
    private func invalidateLayout(atRow row: Int, using context: InvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(forRow: row))
    }
    
    private func invalidateLayout(after indexPath: IndexPath, using context: InvalidationContext) {
        context.invalidateItems(at: calculator.indexPaths(after: indexPath))
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        calculator.reset()
        invalidateLayout()
        return context
    }
}

class MyLayoutAttributes : UICollectionViewLayoutAttributes {

    var shouldIgnore = false

    override func copy(with zone: NSZone? = nil) -> Any {

        let attributes = super.copy(with: zone) as! MyLayoutAttributes
        attributes.shouldIgnore = shouldIgnore

        return attributes
    }

}
