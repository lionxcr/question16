//
//  Constants.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import Foundation

struct AppConstants {
    static let cellIdentifier = "RecipeCell"
    static let recipiesEndPoint = "http://gl-endpoint.herokuapp.com/recipes"
    static let recipeIDEndPoint = "http://gl-endpoint.herokuapp.com/recipes/"
    static let getRecipiesNotification = Notification.Name("GetAllRecipies")
    static let showDetailsVC = "ShowRecipeDetailsVC"
}
