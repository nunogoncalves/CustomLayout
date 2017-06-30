//
//  FixedSizesLayut.swift
//  CustomLayout
//
//  Created by Nuno Castro  on 29/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

final class FixedSizesLayout : UICollectionViewLayout {

    typealias InvalidationContext = UICollectionViewLayoutInvalidationContext
    typealias LayoutAttributes = UICollectionViewLayoutAttributes

    var cache: [LayoutAttributes] = []
    let itemHeight = UICollectionViewFlowLayoutAutomaticSize.height

    override func prepare() {
        super.prepare()

        cache = (0..<numberOfItems).map {
            let indexPath = IndexPath(item: $0, section: 0)

            let layoutAttributes = LayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = frame(for: indexPath)

            return layoutAttributes
        }

    }

    private func frame(for indexPath: IndexPath) -> CGRect {
        let xOrigin = self.xOrigin(for: indexPath.item)
        let yOrigin = self.yOrigin(for: indexPath.item)
        let width = self.itemWidth

        return CGRect(x: xOrigin, y: yOrigin, width: width, height: itemHeight)
    }

    private func xOrigin(for item: Int) -> CGFloat {

        let column = CGFloat(self.column(for: item))

        return xInset + column * itemWidth + xBetweenColumns * column
    }

    private func column(for index: Int) -> Int {
        return index % itemsPerRow
    }

    private func yOrigin(for item: Int) -> CGFloat {

        let row = self.row(for: item)

        if row == 0 {
            return 0
        }

        return (itemHeight + yBetweenRows) * CGFloat(row)
    }

    func row(for index: Int) -> Int {
        return index / itemsPerRow
    }

    var itemWidth: CGFloat {
        return (totalWidth - (2 * xInset) - totalWidthBetweenCells) / CGFloat(itemsPerRow)
    }

    private var totalWidthBetweenCells: CGFloat {
        return xBetweenColumns * CGFloat(itemsPerRow - 1)
    }

    private (set) var itemsPerRow: Int

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
        cache = []
        invalidateLayout()
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }

        let width = collectionView.bounds.width
        let height = frame(for: IndexPath(item: numberOfItems, section: 0)).maxY
        let size = CGSize(width: width, height: height)
        return size
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [LayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
        return cache[indexPath.item]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return (newBounds.width, newBounds.height) != (collectionView!.bounds.width, collectionView!.bounds.height)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)

        invalidateLayout()
        cache = []
        return context
    }
}
