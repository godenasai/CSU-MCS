//
//  UIView+Designable.swift
//  CreatingDesignableUserInterfaces
//
//  Created by Scott Gardner on 2/2/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageView: UIImageView { }
@IBDesignable class DesignableButton: UIButton { }
@IBDesignable class DesignableTextView: UITextView { }
@IBDesignable class DesignableView: UIView { }
@IBDesignable class DesignableSegmentedControl: UISegmentedControl { }
@IBDesignable class DesignableTextField: UITextField {

  @IBInspectable
  var placeholderTextColor: UIColor = UIColor.lightGrayColor() {
    didSet {
      guard let placeholder = placeholder else {
        return
      }
      
      attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
    }
  }
  
}

extension UIView {
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    
    set(newBorderWidth) {
      layer.borderWidth = newBorderWidth
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : nil
    }
    
    set {
      layer.borderColor = newValue?.CGColor
    }
  }
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue != 0
    }
  }
  
  @IBInspectable
  var makeCircular: Bool? {
    get {
      return nil
    }
    
    set {
      if let makeCircular = newValue where makeCircular {
        cornerRadius = min(bounds.width, bounds.height) / 2.0
      }
    }
  }
  
}
