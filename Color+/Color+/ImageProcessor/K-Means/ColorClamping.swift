//
//  ColorClamping.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit

//func safeValue<N: BinaryInteger>(_ num: N) -> CGFloat {
//    let cgNum = num as! CGFloat
//    if(num <= 0) {return 0}
//    if(num >= 255) {return 255}
//    return cgNum
//}

//Helper functions
///Returns 0-255 CGFloat from Int
func validRGB(_ num: Int) -> CGFloat {
    if num <= 0 {return 0}
    if num >= 255 {return 255}
    return CGFloat(num)
}

///Returns 0-255 CGFloat from CGFloat
func validRGB(_ num: CGFloat) -> CGFloat {
    if num <= 0 {return 0}
    if num >= 255 {return 255}
    return CGFloat(num)
}

