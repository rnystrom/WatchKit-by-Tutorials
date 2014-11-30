//
//  RecipesController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit
import SousChefKit

class RecipesController: UITableViewController {

  let recipeStore = RecipeStore()

  override func viewDidLoad() {
    super.viewDidLoad()

    // hack for Xcode 6
    navigationController?.tabBarItem.selectedImage = UIImage(named: "bookmark-full")
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let identifier = segue.identifier

    if identifier == "RecipeDetailSegue" {
      // pass through the selected recipe
      if let path = tableView.indexPathForSelectedRow() {
        let recipe = recipeStore.recipes[path.row]
        let destination = segue.destinationViewController as RecipeDetailController
        destination.recipe = recipe
      }
    }
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeStore.recipes.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as RecipeCell
    let recipe = recipeStore.recipes[indexPath.row]
    cell.recipeLabel.text = recipe.name
    if let url = recipe.imageURL {
      cell.thumbnailView.sd_setImageWithURL(url)
    }
    return cell
  }

}
