//
//  RecipeStepsController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class RecipeStepsInterfaceController: WKInterfaceController {

  @IBOutlet weak var table: WKInterfaceTable!

  let recipe: Recipe?

  override init(context: AnyObject?) {
    super.init(context: context)
    recipe = context as? Recipe

    let rows = recipe?.steps.count ?? 0
    table.setNumberOfRows(rows, withRowType: "StepRow")

    for var i = 0; i < table.numberOfRows; i++ {
      let controller = table.rowControllerAtIndex(i) as StepRowController
      if let step = recipe?.steps[i] {
        controller.textLabel.setText(step)
        controller.stepLabel.setText("Step \(i + 1)")
      }
    }
  }

  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    if let timer = recipe?.timers[rowIndex] {
      if timer > 0 {
        presentControllerWithName("PromptTimer", context: timer)
      }
    }
  }
   
}
