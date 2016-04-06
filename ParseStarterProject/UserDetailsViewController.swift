//
//  UserDetailsViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 3/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse

class UserDetailsViewController: UIViewController {


    var objectId:String = ""
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var userFirstName: UILabel!
    
    @IBOutlet var userLastName: UILabel!
    
    @IBOutlet var typeOfUser: UILabel!
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var graduatingYear: UILabel!
    
    let placeholderImage : UIImage = UIImage(named:"placeholder-hi.png")!
    
    override func viewDidLoad() {
        
        
        let query : PFQuery = PFUser.query()!

        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId == self.objectId {
                            
                            self.userFirstName.text = user["firstName"] as? String
                            self.userLastName.text = user["lastName"] as? String
                            self.typeOfUser.text = user["typeOfStudent"] as? String
                            self.email.text = user["email"] as? String
                            self.graduatingYear.text = user["graduatingYear"] as? String
                            
                            if let userPicture = user["profilePicture"] as? PFFile {
                                userPicture.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                                    if(error == nil) {
                                        
                                        self.profilePicture.image = (UIImage(data:imageData!)!)
                                    } else {
                                        
                                        self.profilePicture.image = self.placeholderImage
                                    }
                                    
                                })
                            } else {
                                
                                self.profilePicture.image = self.placeholderImage
                            }
                            
                        }
                    }
                    
                }
            }
            
            
        })
        
    }
}