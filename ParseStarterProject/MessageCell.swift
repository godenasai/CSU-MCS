//
//  MessageCell.swift
//  CSU-MCS
//
//  Created by Lakshmi sai nadh godena on 4/4/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {

    
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var chatTextViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet var chatTextViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet var senderNameLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet var senderNameRightConstraint: NSLayoutConstraint!
    
    @IBOutlet var senderName: UILabel!
}
