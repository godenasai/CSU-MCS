//
//  ChatCell.swift
//  CSU-MCS
//
//  Created by Lakshmi sai nadh godena on 4/5/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    @IBOutlet var chatTextView: DesignableTextView!
    
    
    @IBOutlet var chatTextViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet var chatTextViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet var senderName: UILabel!
    
    @IBOutlet var senderNameLeftConstraint: NSLayoutConstraint!

    @IBOutlet var senderNameRightConstraint: NSLayoutConstraint!
}
