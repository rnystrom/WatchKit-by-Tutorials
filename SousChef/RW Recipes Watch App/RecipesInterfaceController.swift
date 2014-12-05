//
//  RecipesController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class RecipesInterfaceController: WKInterfaceController {

  let recipeStore = RecipeStore()
  
  @IBOutlet weak var table: WKInterfaceTable!

  override init(context: AnyObject?) {
    super.init(context: context)

    let recipes = recipeStore.recipes
    table.setNumberOfRows(recipes.count, withRowType: "RecipeRowType")
    
    for (index, recipe) in enumerate(recipes) {
      let controller = table.rowControllerAtIndex(index) as RecipeRowController
      controller.textLabel.setText(recipe.name)
      controller.ingredientsLabel.setText("\(recipe.ingredients.count) ingredients")
    }
  }

  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    let recipe = recipeStore.recipes[rowIndex]
    pushControllerWithName("RecipeDetail", context: recipe)
  }
   
}
