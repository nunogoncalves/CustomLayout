//
//  ViewController.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

//    let layout = MyLayout(itemsPerRow: 2)
    let itemsPerRow = 2
    let layout = FlowLayout(itemsPerRow: 2)
//    let layout = FixedSizesLayout(itemsPerRow: 2)
    let selector = UISegmentedControl(items: ["1", "2", "3", "4", "5"])
    let collectionView: UICollectionView

    var rowHeights: [Int: CGFloat] = [:]
    var itemsSize: [Int : CGSize] = [:]

    var heroesList: HeroesList = HeroesList.emptyHeroesList
    
    init() {
        selector.selectedSegmentIndex = 1
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        selector.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
//        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.register(UINib(nibName: "HeroCell", bundle: nil ), forCellWithReuseIdentifier: "HeroCell")
        collectionView.register(Hero2Cell.self, forCellWithReuseIdentifier: "HeroCell")
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        itemsSize = [:]
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(selector)
        selector.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        selector.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(collectionView)
        view.backgroundColor = .white

        collectionView.pinToEdges(of: view, top: 70)
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        searchHeroes()
    }
    
    fileprivate func searchHeroes(in page: Int = 0) {
        Hero.all(in: page, finished: got)
    }
    
    func got(_ heroesList: HeroesList) {
        if heroesList.isFirstPage {
            self.heroesList = heroesList
        } else {
            var heroes = self.heroesList.heroes
            heroes.append(contentsOf: heroesList.heroes)
            self.heroesList = HeroesList(heroes: heroes,
                                         totalCount: heroesList.totalCount,
                                         currentPage: heroesList.currentPage,
                                         totalPages: heroesList.totalCount)
        }
        collectionView.reloadData()
    }
    
    @objc private func layoutChanged() {
        
        UIView.animate(withDuration: 1) {
//            self.layout.updateItemsPerRow(to: self.selector.selectedSegmentIndex + 1)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesList.heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath)  as! Hero2Cell
//        cell.heroTuple = (hero: heroesList.heroes[indexPath.item], i: indexPath.item)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
        cell.hero = heroesList.heroes[indexPath.item]

        return cell
    }
}

extension ViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.item }
        for i in indexes {
            let _ = Cache.ImageLoader.shared.cachedImage(with: heroesList.heroes[i].imageURL)
        }
        
        if indexes.max() == heroesList.heroes.count - 50 {
            searchHeroes(in: heroesList.currentPage + 1)
        }
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
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

        return collectionView.bounds.width / CGFloat(itemsPerRow) - CGFloat(layout.minimumInteritemSpacing) - layout.sectionInset.left
    }

    private func row(for index: Int) -> Int {
        return index / itemsPerRow
    }

    private func height(forRow row: Int) -> CGFloat {
        let cell = TextCell.sharedInstance
        cell.setWidth(itemWidth)

        var maxHeight: CGFloat = 0

        for item in items(forRow: row) {
            cell.hero = heroesList.heroes[item]

            let height = cell.minimumHeight
            maxHeight = max(maxHeight, height)
        }

        return maxHeight
    }

    private func items(forRow row: Int) -> [Int] {
        return Array((row * itemsPerRow)..<itemsPerRow * (row + 1))
    }
}

private extension TextCell {

    func setWidth(_ width: CGFloat) {
        self.frame.size = CGSize(width: width, height: CGFloat(0))
    }
}
