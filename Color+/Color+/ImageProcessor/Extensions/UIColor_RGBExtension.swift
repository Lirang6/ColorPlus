//
//  UIColor_RGBExtension.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit
import CoreImage

extension UIColor {
    var RED: CGFloat {return validRGB(CIColor(color: self).red * 255)}
    var GREEN: CGFloat {return validRGB(CIColor(color: self).green * 255)}
    var BLUE: CGFloat {return validRGB(CIColor(color: self).blue * 255)}
    var ALPHA: CGFloat {return CIColor(color: self).alpha * 255}
    var RGB: [CGFloat] {return [RED, GREEN, BLUE]}
    
    convenience init(pixel: Pixel) {
        self.init(red: pixel.r/255, green: pixel.g/255, blue: pixel.b/255, alpha: 1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

