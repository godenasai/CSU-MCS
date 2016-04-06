//
//  UserCell.swift
//  ParseStarterProject
//
//  Created by Lakshmi sai nadh godena on 3/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var followingImageView: UIImageView!
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var userFirstName: UILabel!
    
    @IBOutlet var typeOfUser: UIImageView!

    @IBOutlet var typeOfUserText: UILabel!
    
    var userObjectId: String = ""
}