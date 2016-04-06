//
//  TableViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 10/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    var usernames = [""]
    var userids = [""]
    var isFollowing = ["":false]
    var searchActive : Bool = false
    var filtered:[String] = []
    var typeOfUser:[String] = [""]
    
    let placeholderImage : UIImage = UIImage(named:"placeholder-hi.png")!
    var profilePictures = [String:UIImage]()
    
    let followingImage: UIImage = UIImage(named: "following_big.png")!
    let followImage: UIImage = UIImage(named: "follow_big.png")!
    let studentType: UIImage = UIImage(named: "student_blue.png")!
    let professorType: UIImage = UIImage(named: "professor_brown.png")!
    let alumniType: UIImage = UIImage(named: "alumni_black.png")!
    
    var refresher: UIRefreshControl!
    
    
    
    var selectedObjectId:String = ""
    
    var swipedObjectId:String = ""
    
    
    @IBAction func logoutPressed(sender: AnyObject) {
        
        PFUser.logOut()
        
        if let currentUser = PFUser.currentUser() {
            
            
        } else {
            self.performSegueWithIdentifier("logout", sender: self)
        }
    }
    
    func refresh() {
        
        let query = PFUser.query()
        
        query?.orderByAscending("firstName")
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.userids.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                self.typeOfUser.removeAll(keepCapacity: true)
                self.profilePictures.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            
                            
                            if let userPicture = user["profilePicture"] as? PFFile {
                                    userPicture.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                                                                       if(error == nil) {
                                        self.usernames.append(user["firstName"] as! String)
                                        self.userids.append(user.objectId!)
                                        self.typeOfUser.append(user["typeOfStudent"] as! String)
                                        self.profilePictures[self.userids.last!] = (UIImage(data:imageData!)!)
                                    } else {
                                        
                                        self.usernames.append(user["firstName"] as! String)
                                        self.userids.append(user.objectId!)
                                        self.typeOfUser.append(user["typeOfStudent"] as! String)

                                        self.profilePictures[self.userids.last!] = self.placeholderImage
                                    }
                                    
                                })
                                }
                            else {
                                self.usernames.append(user["firstName"] as! String)
                                self.userids.append(user.objectId!)
                                self.typeOfUser.append(user["typeOfStudent"] as! String)
                                self.profilePictures[self.userids.last!] = self.placeholderImage
                            }
                            
                            let query = PFQuery(className: "followers")
                            
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                
                                if let objects = objects {
                                    
                                    
                                    if objects.count > 0 {
                                        
                                        self.isFollowing[user.objectId!] = true
                                    }
                                        
                                    else {
                                        
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                }
                                
                            })
                        }
                    }
                    
                }
            }
            
            
        })
        
        
    }
    
    
    
    func swipeRight(recognizer:UISwipeGestureRecognizer) {
        
        
        self.performSegueWithIdentifier("feeds", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.greenColor()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        self.tableView.reloadData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = usernames.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filtered.count
        }
        return usernames.count
    }
    
    var followTapped = false
    
    func followImageTapped (sender: UITapGestureRecognizer) -> Bool{
        
        let tapLocation = sender.locationInView(self.tableView)
        
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        let cell : UserCell = self.tableView.cellForRowAtIndexPath(indexPath!) as! UserCell
        
        let followedObjectId = self.userids[indexPath!.row]
        
        if self.isFollowing[followedObjectId] == false {
            
            self.isFollowing[followedObjectId] = true
            
            
            
            cell.followingImageView.image = self.followingImage
            
            
            let following = PFObject(className: "followers")
            
            following["following"] = self.userids[indexPath!.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
            
        } else {
            
            self.isFollowing[followedObjectId] = false
            
            //cell.accessoryType = UITableViewCellAccessoryType.None
            
            cell.followingImageView.image = self.followImage
            
            let query = PFQuery(className: "followers")
            
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            query.whereKey("following", equalTo: self.userids[indexPath!.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                    }
                }
                
            })
        }
        return true
    }

    
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var chatAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Chat" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.swipedObjectId = self.userids[indexPath.row]
            
            self.performSegueWithIdentifier("chat", sender: self)
        })
        
        return [chatAction]
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserCell

        
        let imageView = cell.followingImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"followImageTapped:")
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Configure the cell...
        if(searchActive){
            
            cell.profilePicture.image = profilePictures[userids[indexPath.row]]
            
            cell.userFirstName.text = filtered[indexPath.row]
            
            cell.userObjectId = userids[indexPath.row]
            
            if(typeOfUser[indexPath.row] == "Professor") {
                
                cell.typeOfUser.image = professorType
            }
            else if(typeOfUser[indexPath.row] == "Alumni") {
                
                cell.typeOfUser.image = alumniType
            } else {
                
                cell.typeOfUser.image = studentType
            }
            
            cell.typeOfUserText.text = typeOfUser[indexPath.row]
           
            
        }
        else {
            cell.profilePicture.image = profilePictures[userids[indexPath.row]]
            
            cell.userFirstName.text = usernames[indexPath.row]
            
            cell.userObjectId = userids[indexPath.row]
            
            if(typeOfUser[indexPath.row] == "Professor") {
                
                cell.typeOfUser.image = professorType
            }
            else if(typeOfUser[indexPath.row] == "Alumni") {
                
                cell.typeOfUser.image = alumniType
            } else {
                
                cell.typeOfUser.image = studentType
            }
            
            cell.typeOfUserText.text = typeOfUser[indexPath.row]

        }
        
        
        let followedObjectId = userids[indexPath.row]

        if isFollowing[followedObjectId] == true {
            
            cell.followingImageView.image = followingImage
            
        }
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedObjectId = userids[indexPath.row]
        
        performSegueWithIdentifier("userDetails", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "userDetails") {
            
            let vc:UserDetailsViewController = segue.destinationViewController as! UserDetailsViewController
            
            vc.objectId = selectedObjectId
        } else if(segue.identifier == "chat") {
            
            let vc: ChatViewControllerTable = segue.destinationViewController as! ChatViewControllerTable
            
            vc.recipientObjectId = swipedObjectId
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setToolbarHidden(false, animated: animated)
        var nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 148/255.0, green: 180/255.0, blue: 136/255.0, alpha: 1.0)
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
}
