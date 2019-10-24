//
//  CustomSearchBar.swift
//  iOS
//
//  Created by Javed Multani on 23/05/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            //searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height - 15.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = COLOR_CUSTOM(255, 255, 255, 1)
        }
        
        
        /* let startPoint = CGPointMake(0.0, frame.size.height)
         let endPoint = CGPointMake(frame.size.width, frame.size.height)
         let path = UIBezierPath()
         path.moveToPoint(startPoint)
         path.addLineToPoint(endPoint)
         
         let shapeLayer = CAShapeLayer()
         shapeLayer.path = path.CGPath
         shapeLayer.strokeColor = preferredTextColor.CGColor
         shapeLayer.lineWidth = 2.5
         
         layer.addSublayer(shapeLayer)*/
        
        super.draw(rect)
    }
    
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        // self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        //        searchBarStyle = UISearchBarStyle.prominent
        //        isTranslucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        // println(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i] is UITextField {
                index = i
                break
            }
        }
        
        return index
    }
}
