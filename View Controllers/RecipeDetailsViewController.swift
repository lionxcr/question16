//
//  RecipeDetailsViewController.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import AlamofireImage

class RecipeDetailsViewController: UIViewController {
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeInstructions: UILabel!
    @IBOutlet weak var instructionsHeight: NSLayoutConstraint!
    
    var sentRecipe:Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Loading instructions...")
        APIManager.shared.getRecipe(withID: self.sentRecipe.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNotificaitonCenter()
    }
    
    func setupNotificaitonCenter(){
        NotificationCenter.default.removeObserver(self, name: AppConstants.getRecipeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotRecipeResponse), name: AppConstants.getRecipeNotification, object: nil)
    }
    
    @objc func gotRecipeResponse(notification: Notification){
        if let data = notification.userInfo{
            if let errorStatus = data["error"] as? Bool{
                if !errorStatus{
                    if let recipe = data["recipe"] as? Recipe{
                        DispatchQueue.main.async {
                            self.recipeTitle.text = recipe.title
                            self.recipeRating.text = "Rating: \(recipe.rating!)"
                            self.instructionsHeight.constant = recipe.instructions!.height(withConstrainedWidth: self.recipeInstructions.frame.width, font: self.recipeInstructions.font)
                            self.recipeInstructions.text = recipe.instructions!
                            self.getImageFromNet(recipe.image!)
                        }
                    }
                }else{
                    //handle errors
                    if let message = data["message"] as? String{
                        print(message)
                    }
                }
            }
            
        }
    }
    
    func getImageFromNet(_ url:String){
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    self.recipeImage.image = image
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                        SwiftSpinner.hide()
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
