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
    
    var yBetweenRows: CGFloat { get }
    var xBetweenColumns: CGFloat { get }
    
    var totalWidth: CGFloat { get }

    var estimatedHeight: CGFloat { get }
}

class LayoutCalculator {
    
    weak var layout: CustomLayout!
    
    private var estimatedHeight: CGFloat {
        return layout.totalWidth / CGFloat(layout.itemsPerRow) * 1.33 + CGFloat(50)
    }
    
    var indexHeights: [Int: CGFloat] = [:]
    var maxHeightsForRows: [Int : CGFloat] = [:]
    
    init(layout: CustomLayout) {
        self.layout = layout
    }
    
    func reset() {
        indexHeights = [:]
        maxHeightsForRows = [:]
    }
    
    var totalHeight: CGFloat {
        let heights = (0..<layout.itemsPerRow).map({ (colum) -> CGFloat in
            let items = self.items(for: colum)
            return items.reduce(0) { (acc, item) in
                return acc + height(for: item) + layout.yBetweenRows
            }
        })
        
        return heights.max() ?? 0
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
        return (0..<layout.numberOfItems).filter { self.column(for: $0) == column }
    }
    
    func row(for index: Int) -> Int {
        return index / layout.itemsPerRow
    }
    
    private func items(forRow row: Int) -> [Int] {
        return (0..<layout.numberOfItems).filter { self.row(for: $0) == row }
    }
    
    func frame(for indexPath: IndexPath) -> CGRect {
        let cvWidth = layout.totalWidth
        let item = indexPath.item
        let itemHeight = self.height(for: item)// indexHeights[item] ?? estimatedHeight
        
        let x = xOrigin(for: item)
        let y = yOrigin(for: item)
        let width = cvWidth / CGFloat(layout.itemsPerRow) - layout.xBetweenColumns / CGFloat(layout.itemsPerRow)
        let height = itemHeight
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func xOrigin(for item: Int) -> CGFloat {
        let xorigin = CGFloat(Int(item % layout.itemsPerRow)) * (layout.totalWidth / CGFloat(layout.itemsPerRow)) + layout.xBetweenColumns
        return xorigin
    }
    
    private func yOrigin(for item: Int) -> CGFloat {
        let itemColum = column(for: item)
        let columItems = items(for: itemColum).filter { $0 < item }
        
        let heightUntilItem = columItems.reduce(CGFloat(0)) { acc, item in
            return acc + height(for: item) + layout.yBetweenRows
        }
        return heightUntilItem
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

