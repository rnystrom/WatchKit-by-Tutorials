//
//  RecipeDetailController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class RecipeDetailInterfaceController: WKInterfaceController {

  @IBOutlet weak var nameLabel: WKInterfaceLabel!
  let recipe: Recipe?

  override init(context: AnyObject?) {
    super.init(context: context)
    recipe = context as? Recipe
    nameLabel.setText(recipe?.name)
  }

  override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
    return recipe
  }

}
