//
//  FirstViewController.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
 
    @IBOutlet weak var recipeTableView: UITableView!
    
    let recipesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNotificaitonCenter()
    }
    
    func setupNotificaitonCenter(){
        NotificationCenter.default.removeObserver(self, name: AppConstants.getRecipiesNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotRecipiesResponse), name: AppConstants.getRecipiesNotification, object: nil)
    }
    
    @objc func gotRecipiesResponse(notification: Notification){
        if let data = notification.userInfo{
            if let errorStatus = data["error"] as? Bool{
                if !errorStatus{
                    if let recipies = data["recipies"] as? [Recipe]{
                        for recipe in recipies{
                            self.recipesArray.add(recipe)
                        }
                        DispatchQueue.main.async {
                            self.recipeTableView.reloadData()
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
    
    func setupTableView(){
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
        self.recipeTableView.reloadData()
        //Get Recipies
        APIManager.shared.getRecipes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.cellIdentifier, for: indexPath) as UITableViewCell
        if let recipe = self.recipesArray.object(at: indexPath.row) as? Recipe{
            cell.textLabel?.text = recipe.title
        }else{
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipe = self.recipesArray.object(at: indexPath.row) as? Recipe{
            print(recipe.id)
            print(recipe.title)
        
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

