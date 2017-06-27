//
//  Hero.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Hero : Equatable {
    let id: Int
    let name: String
    let imageURL: URL
    let description: String?
    
    static func all(named name: String? = nil, in page: Int, finished: @escaping (HeroesList) -> ()) {
        Heroes.Fetcher.fetch(named: name, in: page, got: finished)
    }
    
    static func ==(leftHero: Hero, rightHero: Hero) -> Bool {
        return leftHero.id == rightHero.id && leftHero.name == rightHero.name
    }
}

extension Hero {
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? Int,
            let name = dictionary["name"] as? String,
            let thumb = dictionary["thumbnail"] as? [String : String],
            let thumbPath = thumb["path"],
            let thumbExtension = thumb["extension"],
            let url = URL(string: "\(thumbPath).\(thumbExtension)")
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.imageURL = url
        self.description = (dictionary["description"] as? String ?? "") + " just some description"
    }
}
