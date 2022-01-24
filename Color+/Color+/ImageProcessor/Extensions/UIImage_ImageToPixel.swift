//
//  UIImage_ImageToPixel.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit
import CoreImage

///Inspired by Desmond Hume's answer to https://stackoverflow.com/questions/60247692/how-to-get-the-color-of-a-pixel-in-a-uiimage-in-swift
extension UIImage {
    ///Height of CGImage (or 0)
    var pixelWidth: Int {
        return cgImage?.width ?? 0
    }
    ///Width of underlying CGImage (or 0)
    var pixelHeight: Int {
        return cgImage?.height ?? 0
    }
    
//    func pixelColor(x: Int, y: Int) -> UIColor {
//        assert(0..<pixelWidth ~= x && 0..<pixelHeight ~= y, "Pixel coordinate out of bounds!")
//        
//        guard
//            let cgImage = cgImage,
//            let data = cgImage.dataProvider?.data,
//            let dataPtr = CFDataGetBytePtr(data),
//            let colorSpaceModel = cgImage.colorSpace?.model
//        
//        else {
//            assertionFailure("Could not get the color of a pixel in an image")
//            return .clear
//        }
//        let componentLayout = cgImage.bitmapInfo
//    }
}
