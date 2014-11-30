//
//  RecipeStepsController.swift
//  SousChef
//
//  Created by Ryan Nystrom on 11/24/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

class RecipeStepsController: UITableViewController {

  var steps: [String]?
  var timers: [Int]? // in minutes

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  // MARK: Actions

  func promptToStartTimer(time: Int) {
    let alert = UIAlertController(title: "Start a Timer", message: "Would you like to start a timer for \(time) minutes?", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Start Timer", style: .Default, handler: { _ in
      self.startTimer(time)
    }))
    presentViewController(alert, animated: true, completion: nil)
  }

  func startTimer(time: Int) {
    let fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(time) * 60) // time is in mintues

    let notification = UILocalNotification()
    notification.fireDate = fireDate
    notification.alertBody = "Your cooking timer is done!"
    notification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }

  // MARK: UITableViewDataSource

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let s = steps {
      return s.count
    }
    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RecipeStepsCell", forIndexPath: indexPath) as UITableViewCell
    if let step = steps?[indexPath.row] {
      cell.textLabel?.text = "\(indexPath.row+1). \(step)"
    }
    return cell
  }

  // MARK UITableViewDelegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let timer = timers?[indexPath.row] {
      if timer > 0 { // only prompt for real times
        promptToStartTimer(timer)
      }
    }
  }

}
