//
//  SignUpViewController.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 3/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet var csuEmail: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var reenterPassword: UITextField!
    
    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var lastName: UITextField!
    
    @IBOutlet var typeOfStudent: UISegmentedControl!
    
    @IBOutlet var signUpButton: UIButton!
    
    var typeOfStudentValue = "Alumni";
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
        if(typeOfStudent.selectedSegmentIndex == 0) {
            
            typeOfStudentValue = "Alumni";
        }
        else if(typeOfStudent.selectedSegmentIndex == 1) {
            
            typeOfStudentValue = "Student";
        }
        else {
            
            typeOfStudentValue = "Professor"
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@csu.edu"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    
    
    
    @IBAction func signUpPressed(sender: AnyObject) {
        
        
        
        if csuEmail.text == "" || password.text == "" || reenterPassword.text == "" || firstName.text == "" || lastName.text == "" {
            
            self.displayAlert("Boooom!!", message: "Please enter all the details")
            
        }
        else if(!isValidEmail(csuEmail.text!)) {
            
             self.displayAlert("Boooom!!", message: "Please enter a valid CSU ID")
            
        }
        else if(password.text != reenterPassword.text) {
            
             self.displayAlert("Boooom!!", message: "Passwords do not match")
        }
        
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            //if signUpActive == true {
                
                let user = PFUser()
                user.email = csuEmail.text
                user.username = csuEmail.text
                user.password = password.text
                user.setObject(firstName.text!, forKey: "firstName")
                user.setObject(lastName.text!, forKey: "lastName")
                user.setObject(typeOfStudentValue, forKey: "typeOfStudent")
                
                
                var errorMessage = "Please try again later"
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        self.performSegueWithIdentifier("updateprofile", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Sign Up", message: errorMessage)
                    }
                    
                })
                
        }
        

        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        if PFUser.currentUser() != nil {
//            
//            self.performSegueWithIdentifier("login", sender: self)
//        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
