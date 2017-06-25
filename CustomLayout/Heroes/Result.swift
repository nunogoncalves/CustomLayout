//
//  Result.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 25/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(NetworkError)
}
