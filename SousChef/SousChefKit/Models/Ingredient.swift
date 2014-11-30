//
//  Ingredient.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

public class Ingredient: NSObject, NSCoding, Equatable {

  public let quantity: String
  public let name: String
  public let type: IngredientType

  // MARK: NSCoding

  private let QuantityKey = "QuantityKey"
  private let NameKey = "NameKey"
  private let TypeKey = "TypeKey"

  init(quantity: String, name: String, type: IngredientType) {
    self.quantity = quantity
    self.name = name
    self.type = type
  }

  public required init(coder aDecoder: NSCoder) {
    quantity = aDecoder.decodeObjectForKey(QuantityKey) as String
    name = aDecoder.decodeObjectForKey(NameKey) as String
    type = IngredientType(rawValue: aDecoder.decodeObjectForKey(TypeKey) as String)!
  }

  public func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(quantity, forKey: QuantityKey)
    aCoder.encodeObject(name, forKey: NameKey)
    aCoder.encodeObject(type.rawValue, forKey: TypeKey)
  }

}

public func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
  return lhs.quantity == rhs.quantity &&
  lhs.name == rhs.name &&
  lhs.type == rhs.type
}