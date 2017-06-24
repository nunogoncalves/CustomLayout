//
//  MyLayout.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

public class MyLayout : UICollectionViewLayout {
    
    func updateItemsPerRow(to itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow
        indexHeights = [:]
        invalidateLayout()
    }
    
    private (set) var itemsPerRow: Int
    
    lazy var dx: CGFloat = {
        return CGFloat(self.numberOfItems - 1)
    }()
    let dy: CGFloat = 5
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    let estimatedHeight: CGFloat = 50
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath.item)
    }
    
    func height(for index: Int) -> CGFloat {
        return indexHeights[index] ?? estimatedHeight
    }
    
    var indexHeights: [Int: CGFloat] = [:]
    
    var totalHeight: CGFloat {
        let heights = (0..<itemsPerRow).map({ (colum) -> CGFloat in
            let items = self.items(for: colum)
            return items.reduce(0) { (acc, item) in
                return acc + height(for: item) + dy
            }
        })
            
        return heights.max()!
    }
    
    public init(itemsPerRow: Int) {
        self.itemsPerRow = itemsPerRow > 0 ? itemsPerRow : 1
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let width = collectionView.bounds.width
        let height = totalHeight
        let size = CGSize(width: width, height: height)
        return size
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes: [UICollectionViewLayoutAttributes] = (0..<numberOfItems).flatMap {
            let indexPath = IndexPath(item: $0, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = frame(for: indexPath)
            return attrs
        }
        
        return layoutAttributes
    }
    
    
    private func frame(for indexPath: IndexPath) -> CGRect {
        let cvWidth = collectionView!.bounds.width
        let item = indexPath.item
        let itemHeight = indexHeights[item] ?? estimatedHeight
        
        let x = xOrigin(for: item)
        let y = yOrigin(for: item)
        let width = cvWidth / CGFloat(itemsPerRow) - dx / CGFloat(itemsPerRow)
        let height = itemHeight
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func xOrigin(for item: Int) -> CGFloat {
        let xorigin = CGFloat(Int(item % itemsPerRow)) * (collectionView!.bounds.width / CGFloat(itemsPerRow)) + dx
        return xorigin
    }
    
    private func yOrigin(for item: Int) -> CGFloat {
        let itemColum = column(for: item)
        let columItems = items(for: itemColum).filter { $0 < item }
        
        let heightUntilItem = columItems.reduce(CGFloat(0)) { acc, item in
            return acc + height(for: item) + dy
        }
        return heightUntilItem
    }
    
    private func column(for item: Int) -> Int {
        return item % itemsPerRow
    }
    
    private func isInLastColumn(item: Int) -> Bool {
        return (item + 1) % itemsPerRow == 0
    }
    
    private func items(for column: Int) -> [Int] {
        return (0..<numberOfItems).filter { self.column(for: $0) == column }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attrs = super.layoutAttributesForItem(at: indexPath) else {
            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        
        return attrs
    }
    
//    var maxHeightsForRows: [Int : CGFloat] = []
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        
        let pref = preferredAttributes
        let orig = originalAttributes
        
//        let item = isInLastColumn(item: pref.indexPath.item)
//        if maxHeightsForRows[
        
        
        return pref.frame.height != orig.frame.height
    }
    
    public override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        
        let pref = preferredAttributes
        let orig = originalAttributes
        
        let context = super.invalidationContext(forPreferredLayoutAttributes: pref, withOriginalAttributes: orig)
        
        let oldContentSize = collectionViewContentSize
        indexHeights[orig.indexPath.item] = pref.size.height
        
        let newContentSize = collectionViewContentSize
        
        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)
        
        invalidateLayout(after: originalAttributes.indexPath, for: context)
        
        return context
    }
    
    private func invalidateLayout(after indexPath: IndexPath, for context: UICollectionViewLayoutInvalidationContext) {
        let indexPaths = (indexPath.item..<self.numberOfItems).map { return IndexPath(item: $0, section: 0) }
        context.invalidateItems(at: indexPaths)
    }
}

