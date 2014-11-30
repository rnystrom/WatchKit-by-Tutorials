//
//  RecipeDetailController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit
import SousChefKit

class RecipeDetailController: UIViewController {

  var recipe: Recipe?

  lazy var groceryList = GroceryList()

  enum RecipeDetailSelection: Int {
    case Ingredients = 0, Steps
  }

  lazy var ingredientsController: RecipeIngredientsController! = {
    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("RecipeIngredientsController") as? RecipeIngredientsController
    controller?.recipe = self.recipe
    controller?.tableView.contentInset = self.tableInsets
    return controller
  }()

  lazy var stepsController: RecipeStepsController! = {
    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("RecipeStepsController") as? RecipeStepsController
    controller?.steps = self.recipe?.steps
    controller?.timers = self.recipe?.timers
    controller?.tableView.contentInset = self.tableInsets
    return controller
  }()

  // don't rely on automaticallyAdjustsScrollViewInsets since we're swapping child controllers
  var tableInsets: UIEdgeInsets {
    var insets = UIEdgeInsetsZero
    if let nav = navigationController {
      insets.top = CGRectGetHeight(nav.navigationBar.bounds)
      insets.top += 20 // status bar
    }
    if let tab = tabBarController {
      insets.bottom = CGRectGetHeight(tab.tabBar.bounds)
    }
    return insets
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    updateSelectedController(.Ingredients)
  }

  func onPromptAddGroceries(sender: AnyObject) {
    let name = recipe?.name ?? "this recipe"

    let alert = UIAlertController(title: "Grocery List", message: "Do you want to add all of the ingredients for \(name) to your grocery list?", preferredStyle: .Alert)
    // TODO: add all items to grocery list
    alert.addAction(UIAlertAction(title: "Add Items", style: .Default, handler: { _ in
      if let items = self.recipe?.ingredients {
        for item in items {
          self.groceryList.addItemToList(item)
        }
        self.groceryList.sync()
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }

  @IBAction func onSegmentChange(sender: UISegmentedControl) {
    if let index = RecipeDetailSelection(rawValue: sender.selectedSegmentIndex) {
      updateSelectedController(index)
    } else {
      println("Unsupported recipe detail selection \(sender.selectedSegmentIndex)")
      abort()
    }
  }

  func updateSelectedController(selected: RecipeDetailSelection) {
    switch selected {
    case .Ingredients:
      addSubViewController(ingredientsController)
      stepsController.removeFromSuperViewController()
      navigationItem.rightBarButtonItem = promptActionButton()
      break
    case .Steps:
      addSubViewController(stepsController)
      ingredientsController.removeFromSuperViewController()
      navigationItem.rightBarButtonItem = nil
      break
    }
  }

  func promptActionButton() -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "onPromptAddGroceries:")
  }

}
