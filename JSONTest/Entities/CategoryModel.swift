//
//  Model.swift
//  JSONTest
//
//  Created by Victor on 11/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import Foundation

struct Category: Decodable {
    let id: Int?
    let title: String
    let subs: [Category]?
    
    init(id: Int, title: String, subs: [Category]? = nil){
        self.id = id
        self.title = title
        self.subs = subs
    }
}
