//
//  HeroesList.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

struct HeroesList {
    static let emptyHeroesList = HeroesList(heroes: [], totalCount: 0, currentPage: 0, totalPages: 0)
    
    let heroes: [Hero]
    
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int
    
    var hasMorePages: Bool {
        return currentPage < totalPages
    }
    
    var isFirstPage: Bool {
        return currentPage == 0
    }
    
}
