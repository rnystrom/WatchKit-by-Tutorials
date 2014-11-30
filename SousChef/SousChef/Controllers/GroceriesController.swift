//
//  GroceriesController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit
import SousChefKit

class GroceriesController: UITableViewController {

  lazy var groceryList = GroceryList()
  var selectedIndexPaths = [NSIndexPath]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // hack for Xcode 6
    navigationController?.tabBarItem.selectedImage = UIImage(named: "cart-full")
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    groceryList.reload()
    tableView.reloadData()
  }

  @IBAction func onAction(sender: AnyObject) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    // TODO: remove all items from grocery list
    alert.addAction(UIAlertAction(title: "Clear All Items", style: .Destructive, handler: { _ in
      self.clearAll()
    }))
    alert.addAction(UIAlertAction(title: "Remove Purchased", style: .Default, handler: { _ in
      self.clearSelected()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }

  func clearSelected() {
    tableView.beginUpdates()
    let itemsToRemove = selectedIndexPaths.map({
      self.groceryList.itemForIndexPath($0)!
    })
    for item in itemsToRemove {
      groceryList.removeItem(item)
    }
    groceryList.sync()
    tableView.deleteRowsAtIndexPaths(selectedIndexPaths, withRowAnimation: .Fade)
    selectedIndexPaths = [NSIndexPath]()
    tableView.endUpdates()
  }

  func clearAll() {
    tableView.beginUpdates()
    var allSections = NSMutableIndexSet()
    for section in 0..<numberOfSectionsInTableView(tableView) {
      allSections.addIndex(section)
    }
    tableView.deleteSections(allSections, withRowAnimation: .Fade)
    groceryList.removeAllItems()
    groceryList.sync()
    selectedIndexPaths = [NSIndexPath]()
    tableView.endUpdates()
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return groceryList.sectionCount
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groceryList.numberOfItemsInSection(section)
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell", forIndexPath: indexPath) as UITableViewCell
    cell.accessoryType = .None

    if let item = groceryList.itemForIndexPath(indexPath) {
      cell.textLabel?.text = "\(item.quantity) \(item.name)"

      let quantity = groceryList.quantityForItem(item)
      cell.detailTextLabel?.text = quantity > 1 ? "\(quantity)" : ""

      if contains(selectedIndexPaths, indexPath) {
        cell.accessoryType = .Checkmark
      }
    }

    return cell
  }

  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.97, alpha: 1)

    let label = UILabel()
    label.backgroundColor = view.backgroundColor
    label.textColor = UIColor(white: 0.5, alpha: 1)
    label.font = UIFont.boldSystemFontOfSize(13)
    label.setTranslatesAutoresizingMaskIntoConstraints(false)

    let type = groceryList.sectionForIndex(section)
    label.text = type.rawValue

    view.addSubview(label)

    view.addConstraint(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 15))
    view.addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 15))
    view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))

    return view
  }

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  // MARK: UITableViewDelegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if let index = find(selectedIndexPaths, indexPath) {
      selectedIndexPaths.removeAtIndex(index)
    } else {
      selectedIndexPaths.append(indexPath)
    }

    tableView.reloadData()
  }

}
