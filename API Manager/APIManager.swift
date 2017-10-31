//
//  File.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct APIManager {
    
    static let shared = APIManager()
    
    func getRecipes(){
        let responseObj = NSMutableArray()
        Alamofire.request(AppConstants.recipiesEndPoint).responseJSON { response in
            switch response.result {
            case .success(_):
                if let data = response.result.value{
                    if let recipes = data as? [[String:Any]]{
                        for object in recipes{
                            responseObj.add(Recipe(id:object["id"] as! Int, title:object["title"] as! String, rating: nil, image: nil, instructions: nil))
                        }
                        NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": responseObj, "error": false])
                    }else{
                        NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": responseObj, "error": true, "message": "unwrapping error"])
                    }
                }else{
                    NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": responseObj, "error": true, "message": "parsing error"])
                }
            case .failure(let error):
                NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": responseObj, "error": true, "message": error.localizedDescription])
            }
            
        }
    }
    
    func getRecipe(withID id: Int){
        Alamofire.request("\(AppConstants.recipeIDEndPoint)\(id)").responseJSON { response in
            switch response.result {
            case .success(_):
                if let data = response.result.value{
                    if let recipe = data as? [String:Any]{
                        if let id = recipe["id"] as? Int{
                            if let title = recipe["title"] as? String{
                                if let rating = recipe["rating"] as? Double{
                                    if let image = recipe["image"] as? String{
                                        if let instructions = recipe["instructions"] as? String{
                                            NotificationCenter.default.post(name: AppConstants.getRecipeNotification, object: nil, userInfo: ["recipe": Recipe(id:id, title:title, rating:rating, image:image, instructions: instructions), "error": false])
                                        }
                                    }
                                }
                            }
                        }
                        
                    }else{
                        NotificationCenter.default.post(name: AppConstants.getRecipeNotification, object: nil, userInfo: ["recipe": "nil", "error": true, "message": "unwrapping error"])
                    }
                }else{
                    NotificationCenter.default.post(name: AppConstants.getRecipeNotification, object: nil, userInfo: ["recipe": "nil", "error": true, "message": "parsing error"])
                }
            case .failure(let error):
                NotificationCenter.default.post(name: AppConstants.getRecipeNotification, object: nil, userInfo: ["recipe": "nil", "error": true, "message": error.localizedDescription])
            }
            
        }
    }
}
