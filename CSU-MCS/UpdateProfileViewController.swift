//
//  UpdateProfileViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 3/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UpdateProfileViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var profilePicture: UIButton!
    
    
    @IBOutlet var graduationYear: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var selection: String = ""
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func importImageButtonPressed(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        profilePicture.imageView?.image = image
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        
        if  graduationYear.text == "" {
            
            displayAlert("Error", message: "Please enter your graduation year.")
        }
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if let currentUser = PFUser.currentUser() {
            
            let imageData = UIImageJPEGRepresentation((profilePicture.imageView?.image)!,0.5)
            
            let imageFlie = PFFile(name: "image.png", data: imageData!)
            
            currentUser["profilePicture"] = imageFlie
            
            currentUser["graduationYear"] = graduationYear.text
            
            currentUser.saveInBackground()
            
//            currentUser.saveInBackgroundWithBlock{ (success, error) -> Void in
//                
//                self.activityIndicator.stopAnimating()
//                
//                UIApplication.sharedApplication().endIgnoringInteractionEvents()
//                
//                if error == nil {
//                    
//                    self.displayAlert("Updated!", message: "Your details has been updated successfully.")
//                    
//                    
//                    self.performSegueWithIdentifier("login", sender: self)
//                    
//                } else {
//                    
//                    self.displayAlert("Couldnot post!", message: "Please try again later.")
//                    
//                }
//            }
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
//                if PFUser.currentUser() != nil {
//        
//                    self.performSegueWithIdentifier("login", sender: self)
//                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}