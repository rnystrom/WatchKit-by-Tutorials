//
//  Recipe.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

public class Recipe {

  public let name: String
  public let ingredients: [Ingredient]
  public let steps: [String]
  public let timers: [Int]
  public let imageURL: NSURL?
  public let originalURL: NSURL?

  public init(name: String, ingredients: [Ingredient], steps: [String], timers: [Int], imageURL: NSURL?, originalURL: NSURL?) {
    self.name = name
    self.ingredients = ingredients
    self.steps = steps
    self.timers = timers
    self.imageURL = imageURL
    self.originalURL = originalURL
  }

}