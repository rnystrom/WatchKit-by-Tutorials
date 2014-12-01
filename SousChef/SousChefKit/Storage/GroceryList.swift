//
//  GroceryList.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

public class GroceryList {

  // MARK: Table Convenience

  public func sectionForIndex(index: Int) -> IngredientType {
    return sections[index]
  }

  public var sectionCount: Int {
    return sections.count
  }

  public func sectionForType(type: IngredientType) -> Int? {
    let sections = self.sections
    return find(sections, type)
  }

  public func numberOfItemsInSection(section: Int) -> Int {
    let type = sectionForIndex(section)
    return table[type]?.count ?? 0
  }

  public func itemForIndexPath(path: NSIndexPath) -> Ingredient? {
    let type = sectionForIndex(path.section)
    return table[type]?[path.row]
  }

  public func indexPathForItem(item: Ingredient) -> NSIndexPath? {
    if let group = table[item.type] {
      if let index = find(group, item) {
        return NSIndexPath(forRow: index, inSection: sectionForType(item.type)!)
      }
    }
    return nil
  }

  public func quantityForItem(item: Ingredient) -> Int {
    return list.reduce(0, combine: { acc, ingredient in
      acc + (item == ingredient ? 1 : 0)
    })
  }

  // MARK: Persistence

  public func sync() {
    saveCurrentState()
  }

  public func reload() {
    list = syncedGroceryItems()
    table = updatedTable(list)
  }

  // MARK: List mutability

  public func addItemToList(newItem: Ingredient) {
    // the table is a uniqued list
    if !contains(list, newItem) {
      if var group = table[newItem.type] {
        group.append(newItem)
        table[newItem.type] = group
      }
      table[newItem.type] = [newItem]
    }

    list.append(newItem)
  }

  public func removeItem(oldItem: Ingredient) {
    if var group = table[oldItem.type] {
      if let index = find(group, oldItem) {
        group.removeAtIndex(index)
        table[oldItem.type] = group
      }
    }

    if let index = find(list, oldItem) {
      list.removeAtIndex(index)
    }
  }

  public func removeAllItems() {
    list = GroceryItems()
    table = GroceryTable()
  }

  // MARK: Init

  public init() {
    reload()
  }

  // MARK: Private

  private let savedGroceriesPath: String = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let docPath = paths.first as String
    return "\(docPath)/com.rw.souschef.groceries.json"
  }()

  private typealias GroceryTable = Dictionary<IngredientType, [Ingredient]>
  private typealias GroceryItems = [Ingredient]

  private var list: GroceryItems = GroceryItems()
  private var table: GroceryTable = GroceryTable()

  private var sections: [IngredientType] {
    return table.keys.array
  }

  private func updatedTable(itemList: GroceryItems) -> GroceryTable {
    var table = GroceryTable()
    for item in itemList {
      if var group = table[item.type] {
        if !contains(group, item) {
          group.append(item)
          table[item.type] = group // changing mutable arrays makes a copy in swift, need to reassign
        }
      } else {
        table[item.type] = [item]
      }
    }
    return table
  }

  private func syncedGroceryItems() -> GroceryItems {
    if let data = NSData(contentsOfFile: savedGroceriesPath) {
      if let rawGroceries = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GroceryItems {
        return rawGroceries
      }
    }
    return GroceryItems()
  }

  private func saveCurrentState() {
    let data = NSKeyedArchiver.archivedDataWithRootObject(list)
    if !NSFileManager.defaultManager().createFileAtPath(savedGroceriesPath, contents: data, attributes: nil) {
      println("error saving grocery list")
    }
  }

}