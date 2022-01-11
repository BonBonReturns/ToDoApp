//
//  Colors.swift
//  ColorsFramework
//
//  Created by Ayush Tiwari on 20/04/21.
//

import Foundation
import UIKit

public class Colors {
    
    var allColor = [0xd0fffd, 0xffdda, 0xe4ffde, 0xffd4fc, 0xfee7d2, 0xacddde, 0xcbe4f9, 0xc5e1a5, 0x99e6ff, 0xb8d3d8]
    
    public init() {
        // Init
    }
    
    public func getRandomColor() -> UIColor {
        if let color = allColor.randomElement() {
            return UIColor(color)
        } else {
            return UIColor(allColor[0])
        }
    }
    
    public func getOrderedColor(index: Int) -> UIColor {
        UIColor(allColor[index % allColor.count])
    }
    
    public func addColor(color: Int) {
        allColor.append(color)
    }
}

extension UIColor {
     public convenience init(_ value: Int) {
         let red = CGFloat(value >> 16 & 0xFF) / 255.0
         let green = CGFloat(value >> 8 & 0xFF) / 255.0
         let blue = CGFloat(value & 0xFF) / 255.0
         self.init(red: red, green: green, blue: blue, alpha: 1.0)
     }
}
