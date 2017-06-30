//
//  LayoutCalculator.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol CustomLayout: class {
    
    var numberOfItems: Int { get }
    var itemsPerRow: Int { get }

    var xInset: CGFloat { get }

    var xBetweenColumns: CGFloat { get }
    var yBetweenRows: CGFloat { get }
    
    var totalWidth: CGFloat { get }
}

final class LayoutCalculator {
    
    weak var layout: CustomLayout!

//    private var estimatedHeight = UICollectionViewFlowLayoutAutomaticSize.height
    private var estimatedHeight: CGFloat {
        return layout.totalWidth / CGFloat(layout.itemsPerRow) * 1.33 + CGFloat(50)
    }

    var indexHeights: [Int: CGFloat] = [:]
    var maxHeightsForRows: [Int : CGFloat] = [:]
    var originForColumns: [Int : CGFloat] = [:]
    
    init(layout: CustomLayout) {
        self.layout = layout
    }
    
    func reset() {
        indexHeights = [:]
        maxHeightsForRows = [:]
        originForColumns = [:]
    }
    
    var totalHeight: CGFloat {
        return self.frame(for: IndexPath(item: layout.numberOfItems, section: 0)).maxY
    }
    
    func frame(for indexPath: IndexPath) -> CGRect {
        let item = indexPath.item
        let itemHeight = self.height(for: item)
        
        let x = xOrigin(for: item)
        let y = yOrigin(for: item)
        let width = itemWidth
        let height = itemHeight
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func xOrigin(for item: Int) -> CGFloat {
        
        let column = self.column(for: item)
        
        if let origin = originForColumns[column] {
            return origin
        }
        
        let fColum = CGFloat(column)
        let origin = layout.xInset + fColum * itemWidth + layout.xBetweenColumns * fColum
        originForColumns[column] = origin
        
        return origin
    }
    
    private func yOrigin(for item: Int) -> CGFloat {
        let itemColumn = column(for: item)
        let columItems = items(for: itemColumn).filter { $0 < item }
        
        let heightUntilItem = columItems.reduce(CGFloat(0)) { acc, item in
            return acc + height(for: item) + layout.yBetweenRows
        }
        return heightUntilItem
    }
    
    func height(for index: Int) -> CGFloat {
        return maxHeightsForRows[row(for: index)] ?? indexHeights[index] ?? estimatedHeight
    }
    
    func height(for indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath.item)
    }
    
    func column(for index: Int) -> Int {
        return index % layout.itemsPerRow
    }
    
    func isInLastColumn(index: Int) -> Bool {
        return (index + 1) % layout.itemsPerRow == 0
    }
    
    func items(for column: Int) -> [Int] {
        //can't cache this becauase of pagination for example.
        return Array(stride(from: column, to: layout.numberOfItems, by: layout.itemsPerRow))
    }
    
    func row(for index: Int) -> Int {
        return index / layout.itemsPerRow
    }
    
    private func items(forRow row: Int) -> [Int] {
        return Array((row * layout.itemsPerRow)..<(row * layout.itemsPerRow + layout.itemsPerRow))
    }
    
    private var totalWidthBetweenCells: CGFloat {
        return layout.xBetweenColumns * CGFloat(layout.itemsPerRow - 1)
    }

    private var itemWidth: CGFloat {
        return (layout.totalWidth - (2 * layout.xInset) - totalWidthBetweenCells) / CGFloat(layout.itemsPerRow)
    }
    
    func indexPaths(after indexPath: IndexPath) -> [IndexPath] {
        return (indexPath.item..<layout.numberOfItems).map { return IndexPath(item: $0, section: 0) }
    }
    
    func indexPaths(forRow row: Int) -> [IndexPath] {
        let indexPaths: [IndexPath] = items(forRow: row).flatMap { item in
            if item < 0 { return nil }
            return IndexPath(item: item, section: 0)
        }
        return indexPaths
    }
    
}

