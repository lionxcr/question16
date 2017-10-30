//
//  File.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import Foundation
import Alamofire

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
                        
                        NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": "nil", "error": false])
                    }else{
                        NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": "nil", "error": true, "message": "unwrapping error"])
                    }
                }else{
                    NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": "nil", "error": true, "message": "parsing error"])
                }
            case .failure(let error):
                NotificationCenter.default.post(name: AppConstants.getRecipiesNotification, object: nil, userInfo: ["recipies": "nil", "error": true, "message": error.localizedDescription])
            }
            
        }
    }
}
