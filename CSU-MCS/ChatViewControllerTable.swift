//
//  ChatViewControllerTable.swift
//  CSU-MCS
//
//  Created by Lakshmi sai nadh godena on 4/5/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ChatViewControllerTable: UIViewController, UITableViewDelegate, UITextViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextView: DesignableTextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var dockViewHeightConstraint: NSLayoutConstraint!
    
    var recipientObjectId:String = ""
    
    var messagesArray:[Int:[String]] = [Int:[String]]()
    
    var messageTextViewBiggerRight:CGFloat = 0
    var senderNameBiggerRight:CGFloat = 0
    
    var keyboardHeight:CGFloat = 0
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        let newMessage:PFObject = PFObject(className: "Products")
        
        newMessage["Message"] = self.messageTextView.text
        
        newMessage["sender"] = PFUser.currentUser()?.objectId
        
        newMessage["other"] = recipientObjectId
        
        newMessage.saveInBackgroundWithBlock { (sucess, error) -> Void in
            
            if(sucess) {
                
                self.retrieveMessages()
                
            } else {
                
                NSLog(error!.description)
            }
        }
        
        self.messageTextView.text = ""

        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        
        self.keyboardHeight = keyboardRectangle.height
        
        print("Keyboard Height", self.keyboardHeight)
    }
    
    
    func retrieveMessages() {
        
        var query:PFQuery = PFQuery(className: "Products")
        
        query.whereKey("sender", containedIn: [recipientObjectId,(PFUser.currentUser()?.objectId)!])
        query.whereKey("other", containedIn: [recipientObjectId,(PFUser.currentUser()?.objectId)!])
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            self.messagesArray = [Int:[String]]()
            
            if let objects = objects {
                
                var counter:Int = 0
                for object in objects {
                    
                    
                    
                    let messageText:String = object["Message"] as! String
                    
                    self.messagesArray[counter] = [object["sender"] as! String,messageText]
                    
                    counter++
                }
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       let newMessage:PFObject = PFObject(className: "Messages")
        
        newMessage["message"] = "testing"
        
        newMessage.saveInBackground()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        self.navigationController?.title = self.recipientObjectId
        
        messageTextViewBiggerRight = self.view.frame.width * 0.3
        senderNameBiggerRight = self.view.frame.width * 0.5
        
        self.messageTextView.text = "Type something..."
        messageTextView.textColor = UIColor.lightGrayColor()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.messageTextView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")

        self.tableView.addGestureRecognizer(tapGesture)
        
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeAction")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.tableView.addGestureRecognizer(rightSwipe)
        
        self.retrieveMessages()
        
    }
    
    
    func swipeAction() {
        
        
    }
    func tableViewTapped() {
        
        self.messageTextView.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if messageTextView.textColor == UIColor.lightGrayColor() {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.blackColor()
        }
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.dockViewHeightConstraint.constant = self.dockViewHeightConstraint.constant + self.keyboardHeight
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if messageTextView.text.isEmpty {
            messageTextView.text = "Type something..."
            messageTextView.textColor = UIColor.lightGrayColor()
        }
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.dockViewHeightConstraint.constant = 60
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    
    // MARK: - Table view delegate methods
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
      
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! ChatCell
        
        
        let user = PFUser.query()
        
        user?.whereKey("objectId", equalTo: self.messagesArray[indexPath.item]![0])
        
        user?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    cell.senderName.text = object["firstName"] as! String
                }
            }
            
        })
        
        cell.chatTextView.layoutIfNeeded()
        
        
        
        cell.chatTextView.text = self.messagesArray[indexPath.item]![1]
        
        
        print("cell description",cell.chatTextView.description)
        
        //if checkCounter < messagesArray.count {
        
        
            
            if(self.messagesArray[indexPath.item]![0] != PFUser.currentUser()?.objectId) {
                
                cell.chatTextView.backgroundColor = UIColor.lightGrayColor()
                
                cell.chatTextViewLeftConstraint.constant = 15
                cell.chatTextViewRightConstraint.constant = messageTextViewBiggerRight
                cell.senderNameLeftConstraint.constant = 15
                cell.senderNameRightConstraint.constant = senderNameBiggerRight
                
                cell.senderName.textAlignment = .Left
                cell.chatTextView.textAlignment = .Left
            }
            else {
                cell.chatTextView.backgroundColor = UIColor(red: 173/255.0, green: 198/255.0, blue: 166/255.0, alpha: 1.0)
                
                cell.chatTextViewLeftConstraint.constant = messageTextViewBiggerRight
                cell.chatTextViewRightConstraint.constant = 15
                cell.senderNameLeftConstraint.constant = senderNameBiggerRight
                cell.senderNameRightConstraint.constant = 15
                cell.senderName.textAlignment = .Right
                cell.chatTextView.textAlignment = .Right
                
            }
       // }
        
        
        
        cell.layoutIfNeeded()
        print("cell height find",cell.description)
        
        return cell
    }
    
    
}
