//
//  hexToString.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 18/02/21.
//

import UIKit

extension UIColor {
     public convenience init(_ value: Int) {
         let red = CGFloat(value >> 16 & 0xFF) / 255.0
         let green = CGFloat(value >> 8 & 0xFF) / 255.0
         let blue = CGFloat(value & 0xFF) / 255.0
         self.init(red: red, green: green, blue: blue, alpha: 1.0)
     }
}
