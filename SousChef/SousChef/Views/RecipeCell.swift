//
//  RecipeCell.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/25/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var recipeLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    thumbnailView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
    thumbnailView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
  }

}
