//
//  Extension_UIColor.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit
import CoreImage


extension UIImage {
    func colorArray() -> [UIColor] {
        var result: [[CGFloat]] = []


        let img = self.cgImage
        let width = img!.width
        let height = img!.height
//        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let rawData: [UInt8] = Array(repeating: 0, count: width * height * 4)
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
//        let bytesPerComponent = 8

//        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        /*
        let context = CGContext(data: &rawData, width: width, height: height, bitsPerComponent: bytesPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        let newRect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
 */

//        CGContextDrawImage(context, newRect, img);
        for x in 0..<width {
            for y in 0..<height {
                let byteIndex = (bytesPerRow * x) + y * bytesPerPixel

                let red   = CGFloat(rawData[byteIndex]    ) / 255.0
                let green = CGFloat(rawData[byteIndex + 1]) / 255.0
                let blue  = CGFloat(rawData[byteIndex + 2]) / 255.0
//                let alpha = CGFloat(rawData[byteIndex + 3]) / 255.0

                let color = [red, green, blue]
                result.append(color)
            }
        }

        return []
    }
}

