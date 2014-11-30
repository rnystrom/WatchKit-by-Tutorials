//
//  RecipeIngredientsController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class RecipeIngredientsInterfaceController: WKInterfaceController {

  @IBOutlet weak var table: WKInterfaceTable!

  let recipe: Recipe?
  let groceryList = GroceryList()

  override init(context: AnyObject?) {
    super.init(context: context)
    recipe = context as? Recipe

    let rows = recipe?.ingredients.count ?? 0
    table.setNumberOfRows(rows, withRowType: "IngredientRow")

    for var i = 0; i < table.numberOfRows; i++ {
      let controller = table.rowControllerAtIndex(i) as IngredientRowController
      if let ingredient = recipe?.ingredients[i] {
        controller.textLabel.setText(ingredient.name.capitalizedString)
        controller.detailLabel.setText(ingredient.quantity)
      }
    }
  }
   
  @IBAction func onAddToGrocery() {
    if let items = self.recipe?.ingredients {
      for item in items {
        groceryList.addItemToList(item)
      }
      groceryList.sync()
    }
  }

}
