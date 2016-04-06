//
//  FeedTableViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 10/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController{

    var messages = [String]()
    var usernames = [String]()
    var postedTimes = [String]()
    var typeOfMessages = [String]()
    var userids = [String]()
    var profilePictures = [String:UIImage]()
    
    let placeholderImage : UIImage = UIImage(named:"placeholder-hi.png")!
    
    func swipeLeft(recognizer:UISwipeGestureRecognizer) {
        
        
        self.performSegueWithIdentifier("userlist", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 132
        let getFollowedUsersQuery = PFQuery(className: "followers")
        
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollowedUsersQuery.orderByDescending("createdAt")
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                self.messages.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
              //  self.imageFiles.removeAll(keepCapacity: true)
                self.postedTimes.removeAll(keepCapacity: true)
                self.typeOfMessages.removeAll(keepCapacity: true)
                self.profilePictures.removeAll(keepCapacity: true)
                 self.userids.removeAll(keepCapacity: true)
                
                for object in objects {
                    
                    let followedUser = object["following"] as! String
                    
                    let query = PFQuery(className: "Post")
                    
                    
                    query.whereKey("userId", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                       
                            for object in objects {
                                
                                self.messages.append(object["message"] as! String)
                                
                                let seconds:NSTimeInterval = NSDate().timeIntervalSinceDate(object.createdAt! as NSDate)
                                
                                self.postedTimes.append(TimeConversion.timeElapsed(seconds))
                                
                                self.typeOfMessages.append(object["typeOfMessage"] as! String)
                                
                                self.userids.append(object["userId"] as! String)
                                
                                let usernamesQuery = PFUser.query()
                                
                                usernamesQuery?.whereKey("objectId", equalTo: object["userId"] as! String)
                                usernamesQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                    if let objects = objects {
                                        
                                        for object in objects {
                                           print("success")
                                            
                                           self.usernames.append(object["firstName"] as! String)
                                            self.tableView.reloadData()
                                        }
                                    }
                                })
                                
                                
                            }
                        }
                        
                    })
                }
            }
            
        }

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//       // let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath) as! Cell
//        
//        
//        
//        //cell.message.text = messages[indexPath.row]
//        //cell.message.sizeToFit()
//        
//        return 222.0
//        
//    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        
        cell.username.text = usernames[indexPath.row]
        
        print("Before",cell.message.frame.size.height)
        
        cell.message.layoutIfNeeded()
        
        cell.message.text = messages[indexPath.row]
        
        print("After",cell.message.frame.size.height)
        
//        cell.message.sizeToFit()
//    
//        let bounds = cell.bounds
//        
//        print(bounds.height+cell.message.bounds.height)
//        
//        
//        cell.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height+cell.message.bounds.height)
        
        let user = PFUser.query()
        user!.whereKey("objectId", equalTo: self.userids[indexPath.row] as! String)
        
        user?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    if let userPicture = object["profilePicture"] as? PFFile {
                        
                     userPicture.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        
                        if error == nil {
                            
                            cell.profilePicture.image = UIImage(data: data!)
                            cell.username.text = object["firstName"] as! String
                        } else {
                            
                            cell.profilePicture.image = self.placeholderImage
                            cell.username.text = object["firstName"] as! String
                        }
                     })
                    } else {
                        
                        cell.profilePicture.image = self.placeholderImage
                        cell.username.text = object["firstName"] as! String
                    }
                    
                }
            }
            
        })
        
        //cell.profilePicture.image = profilePictures[usernames[indexPath.row]]
        
        if(typeOfMessages[indexPath.row] == "High Alert") {
            
            cell.typeOfMessage.image = UIImage(named: "rect_red.png")
            
        }
        else if (typeOfMessages[indexPath.row] == "Moderate") {
            
            cell.typeOfMessage.image = UIImage(named: "rect_orange.png")
        }
        else {
            
            cell.typeOfMessage.image = UIImage(named: "rect_blue.png")
        }
        
        cell.postedTime.text = postedTimes[indexPath.row]

        print(cell.message.frame.size.height)
        
        
        
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
