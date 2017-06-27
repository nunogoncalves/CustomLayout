//
//  ViewController.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UICollectionViewDataSource {
    
    let layout = MyLayout(itemsPerRow: 2)
    let selector = UISegmentedControl(items: ["1", "2", "3", "4", "5"])
    let collectionView: UICollectionView
    
    var heroesList: HeroesList = HeroesList.emptyHeroesList
    
    init() {
        selector.selectedSegmentIndex = 1
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        selector.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
//        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: "HeroCell", bundle: nil ), forCellWithReuseIdentifier: "HeroCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        view.addSubview(selector)
        selector.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        selector.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .orange
        collectionView.pinToEdges(of: view, top: 70)
        
        collectionView.dataSource = self
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
            self.layout.updateItemsPerRow(to: self.selector.selectedSegmentIndex + 1)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesList.heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath)  as! HeroCell
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
        
        if indexes.max() == heroesList.heroes.count - 1 {
            searchHeroes(in: heroesList.currentPage + 1)
        }
    }
}

