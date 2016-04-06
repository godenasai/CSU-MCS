//
//  PostImageViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 10/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController {

    
    @IBOutlet var messageTextArea: UITextView!
    
    @IBOutlet var typeOfMessageSegmentedControl: UISegmentedControl!
    
    var typeOfMessageValue = "High Alert"
    
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    var selection: String = ""
    
    func displayAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    }))
    
    self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    
    @IBAction func typeOfMessageValueChanged(sender: AnyObject) {
        
        if(typeOfMessageSegmentedControl.selectedSegmentIndex == 0) {
            
            typeOfMessageValue = "High Alert"
        } else if (typeOfMessageSegmentedControl.selectedSegmentIndex == 1) {
            
            typeOfMessageValue = "Moderate"
        } else {
            
            typeOfMessageValue = "Normal"
        }
        
    }
    
    
    

    @IBAction func postItButton(sender: AnyObject) {
        
        
        
        
        if  messageTextArea.text == "" {
            
            displayAlert("Error", message: "Please enter all the fields.")
        }
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Post")
        
        post["message"] = messageTextArea.text
        
        post["userId"] = PFUser.currentUser()?.objectId
        
//        if(self.selection == "image") {
//            
//            let imageData = UIImageJPEGRepresentation(imageToPost.image!,0.5)
//            
//            let imageFile = PFFile(name: "image.png", data: imageData!)
//            
//            post["imageFile"] = imageFile
//
//        }
        
        
        
        post["typeOfMessage"] = typeOfMessageValue
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Posted!", message: "News has been posted successfully.")
                
                
                
                self.messageTextArea.text = ""
                
            } else {
                
                self.displayAlert("Couldnot post!", message: "Please try again later.")
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
