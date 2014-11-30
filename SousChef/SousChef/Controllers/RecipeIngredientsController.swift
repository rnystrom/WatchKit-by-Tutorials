//
//  RecipeIngredientsController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit
import SousChefKit

class RecipeIngredientsController: UITableViewController {

  @IBOutlet weak var bannerView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

  var selectedIngredientPaths = [NSIndexPath]()
  var recipe: Recipe?
  var originalHeaderHeight: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    originalHeaderHeight = headerHeightConstraint.constant

    titleLabel.text = recipe?.name
    if let url = recipe?.imageURL {
      bannerView.sd_setImageWithURL(url)
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let ing = recipe?.ingredients {
      return ing.count
    }
    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RecipeIngredientsCell", forIndexPath: indexPath) as UITableViewCell

    if let item = recipe?.ingredients[indexPath.row] {
      let text = "\(item.quantity) \(item.name)"

      var attributes: [NSObject: AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(17)];

      // lighten and strikethrough the ingredient if we have added it
      if contains(selectedIngredientPaths, indexPath) {
        attributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        attributes[NSStrikethroughStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
      } else {
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
      }

      cell.textLabel?.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    return cell
  }

  // MARK: UITableViewDelegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let index = find(selectedIngredientPaths, indexPath) {
      selectedIngredientPaths.removeAtIndex(index)
    } else {
      selectedIngredientPaths.append(indexPath)
    }
    tableView.reloadData()
  }

  // MARK: UIScrollViewDelegate

  override func scrollViewDidScroll(scrollView: UIScrollView) {
    headerHeightConstraint.constant = originalHeaderHeight - scrollView.contentOffset.y
  }

}
