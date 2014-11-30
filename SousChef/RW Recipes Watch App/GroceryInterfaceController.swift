//
//  GroceryInterfaceController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/26/14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import WatchKit
import SousChefKit

class GroceryInterfaceController: WKInterfaceController {

  @IBOutlet weak var table: WKInterfaceTable!
  var selectedRows = [Int]()
  let groceryList = GroceryList()

  typealias FlatGroceryItem = (item: AnyObject, id: String)

  // this method isn't cheap, use it wisely
  lazy var flatList: [FlatGroceryItem] = {
    return self.flattenedGroceries()
  }()

  override init(context: AnyObject?) {
    super.init(context: context)

    updateTable()
  }

  func updateTable() {
    table.setRowTypes(flatList.map({ $0.id }))

    for var i = 0; i < table.numberOfRows; i++ {
      let controller: AnyObject! = table.rowControllerAtIndex(i)
      let context = flatList[i]

      if let c = controller as? GroceryTypeController {
        let type = context.item as String
        c.textLabel.setText(type)
        c.imageView.setImage(UIImage(named:type.lowercaseString))
      } else if let c = controller as? GroceryRowController {
        let item = context.item as Ingredient
        c.textLabel.setText(item.name.capitalizedString)
        c.detailLabel.setText(item.quantity)

        let quantity = groceryList.quantityForItem(item)
        let quantityText = quantity > 1 ? "x\(quantity)" : ""
        c.quantityLabel.setText(quantityText)
      }
    }
  }

  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    if let c = table.rowControllerAtIndex(rowIndex) as? GroceryRowController {
      let item = flatList[rowIndex].item as Ingredient
      let text = item.name.capitalizedString

      var attributes: [NSObject: AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(16)];

      if let index = find(selectedRows, rowIndex) {
        selectedRows.removeAtIndex(index)

        attributes[NSForegroundColorAttributeName] = UIColor.whiteColor()
      } else {
        selectedRows.append(rowIndex)

        attributes[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        attributes[NSStrikethroughStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
      }

      let attributedText = NSAttributedString(string: text, attributes: attributes)

      c.textLabel.setAttributedText(attributedText)
    }
  }

  func flattenedGroceries() -> [FlatGroceryItem] {
    var list = [FlatGroceryItem]()

    for section in 0..<self.groceryList.sectionCount {
      let type = self.groceryList.sectionForIndex(section)
      list.append((type.rawValue, "GroceryTypeRow"))

      for row in 0..<self.groceryList.numberOfItemsInSection(section) {
        if let item = self.groceryList.itemForIndexPath(NSIndexPath(forRow: row, inSection: section)) {
          list.append((item, "GroceryRow"))
        }
      }
    }

    return list
  }

  @IBAction func onClearAll() {
    let indices = NSIndexSet(indexesInRange: NSRange(location: 0, length: table.numberOfRows))
    table.removeRowsAtIndexes(indices)
    groceryList.removeAllItems()
    flatList = flattenedGroceries()
    selectedRows = [Int]()
  }

  @IBAction func onRemovePurchased() {
    var indexSet = NSMutableIndexSet()

    for index in selectedRows {
      indexSet.addIndex(index)

      let item = flatList[index].item as Ingredient
      groceryList.removeItem(item)
    }

    table.removeRowsAtIndexes(indexSet)
    flatList = flattenedGroceries()
    selectedRows = [Int]()
  }


}
