//
//  ProfileModalViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 3/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse

class ProfileModalViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var userfNamelName: UILabel!
    
    @IBOutlet var typeOfStudent: UILabel!
    
    @IBOutlet var email: UILabel!
    
    @IBOutlet var graduationYear: UILabel!

    @IBOutlet var lastName: UILabel!
    
    @IBOutlet var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        
        
        typeOfStudent.text = PFUser.currentUser()?.objectForKey("typeOfStudent") as? String
        
        email.text = PFUser.currentUser()?.objectForKey("email") as? String
        
        graduationYear.text = PFUser.currentUser()?.objectForKey("graduationYear") as? String
        
        userfNamelName.text = PFUser.currentUser()?.objectForKey("firstName") as? String

        lastName.text = PFUser.currentUser()?.objectForKey("lastName") as? String
        
        if let userPicture = PFUser.currentUser()?.objectForKey("profilePicture") as? PFFile {
            
            userPicture.getDataInBackgroundWithBlock({ (data, error) -> Void in
                
                self.profilePicture.image = UIImage(data: data!)
            })
        }
        
    }
    
    @IBAction func clickedUpdateButton(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        
        let imageData = UIImageJPEGRepresentation(profilePicture.image!,0.5)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        user!["profilePicture"] = imageFile
        do {
            try user?.save()
        }
        catch {
            
        }
    }
    
    @IBAction func clickedUploadImage(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        profilePicture.image = image
        
    }
    
    

}
