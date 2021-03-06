//
//  FirstViewController.swift
//  GorillaQuestion16
//
//  Created by Pablo Segura on 10/30/17.
//  Copyright © 2017 LionX Dev. All rights reserved.
//

import UIKit
import SwiftSpinner

class RecipeViewController: UIViewController {
 
    @IBOutlet weak var recipeTableView: UITableView!
    
    let recipesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Recipes"
        self.setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.recipesArray.count == 0{
            SwiftSpinner.show("Gethering recipies...")
            APIManager.shared.getRecipes()
        }
       
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
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                                SwiftSpinner.hide()
                            })
                            
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipe = sender as? Recipe{
            if let vc = segue.destination as? RecipeDetailsViewController{
                vc.sentRecipe = recipe
            }
        }
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
            self.performSegue(withIdentifier: AppConstants.showDetailsVC, sender: recipe)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

