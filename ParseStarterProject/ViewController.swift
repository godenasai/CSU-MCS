//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpActive = false
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    
    @IBOutlet var backgroundImageWidthContraint: NSLayoutConstraint!
    @IBOutlet var backgroundImageHeightConstraint: NSLayoutConstraint!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    
    @IBAction func clickedSignUpButton(sender: AnyObject) {
        self.performSegueWithIdentifier("signup", sender: self)
        
    }
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        
//        if username.text == "" || password.text == "" {
//         return true
//        } else {
//            return false
//        }
//    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        
        let bounds = self.signUpButton.bounds
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.signUpButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 10, height: bounds.size.height)
                        }, completion: nil)
        
        
        if username.text == "" || password.text == "" {
            
           displayAlert("Boooom!!", message: "Please enter the username and password")
            self.signUpButton.bounds = CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
           
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        // Logged In
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                           self.displayAlert("Failed Login", message: errorString)
                        }
                        
                        
                        
                    }
                    
                })
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.layoutIfNeeded()
//        UIView.animateWithDuration(4) { () -> Void in
//            self.backgroundImageWidthContraint.constant = 800
//            self.backgroundImageHeightConstraint.constant = 820
//            self.view.layoutIfNeeded()
//        }

    }

    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("login", sender: self)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {

        self.navigationController?.navigationBar.hidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

