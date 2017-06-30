//
//  FlowLayout.swift
//  CustomLayout
//
//  Created by Nuno Castro  on 30/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

final class FlowLayout : UICollectionViewFlowLayout {

    private let itemsPerRow: Int

    var rowHeights: [Int: CGFloat] = [:]
    var itemsSize: [Int : CGSize] = [:]

    init(itemsPerRow: Int) {

        self.itemsPerRow = itemsPerRow
        super.init()
        self.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        self.minimumInteritemSpacing = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FlowLayout : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = itemsSize[indexPath.item] {
            return size
        }

        let row = self.row(for: indexPath.item)

        let rowHeight = self.height(forRow: row)

        for rowItem in 0..<itemsPerRow {
            itemsSize[indexPath.item + rowItem] = CGSize(width: itemWidth, height: rowHeight)
        }

        return CGSize(width: itemWidth, height: rowHeight)
    }

    private var itemWidth: CGFloat {

        return collectionView!.bounds.width / CGFloat(itemsPerRow)
    }

    private func row(for index: Int) -> Int {
        return index / itemsPerRow
    }

    private func height(forRow: Int) -> CGFloat {

        return 0
    }

    private func items(forRow row: Int) -> [Int] {
        return Array((row * itemsPerRow)..<itemsPerRow * (row + 1))
    }
}
