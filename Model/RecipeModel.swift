//
//  RecipeModel.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import Foundation

struct Recipe {
    let id:Int!
    let title:String!
    let rating:Double?
    let image:String?
    let instructions:String?
    
    init(id:Int, title:String, rating:Double?, image:String?, instructions:String? ) {
        self.id = id
        self.title = title
        
        if let r = rating{
            self.rating = r
        }else{
            self.rating = nil
        }
        
        if let img = image{
            self.image = img
        }else{
            self.image = nil
        }
        
        if let ins = instructions{
            self.instructions = ins
        }else{
            self.instructions = nil
        }
    }
}
