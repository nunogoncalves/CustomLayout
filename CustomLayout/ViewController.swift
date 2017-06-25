//
//  ViewController.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UICollectionViewDataSource {
    
    let layout = MyLayout(itemsPerRow: 3)
    let selector = UISegmentedControl(items: ["1", "2", "3", "4", "5"])
    let collectionView: UICollectionView
    
    
    init() {
        selector.selectedSegmentIndex = 2
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        selector.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
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
    }
    
    @objc private func layoutChanged() {
        
        UIView.animate(withDuration: 1) {
            self.layout.updateItemsPerRow(to: self.selector.selectedSegmentIndex + 1)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as! Cell
        cell.label.text = strings[indexPath.item]
        return cell
    }
    
}

