//
//  UIImage_ToPixel.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
    /*
    func getRGB() -> [Pixel] {
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        //Main logic: Iterate through pixel
        if let cfData = self.cgImage?.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
            for x in 0..<width {
                for y in 0..<width {
                    ge
                }
            }
        }
    
    }
    */
    
    ///Represents UIImage as an array of [Pixel] (0-255), verified
    private func displayToPixels() -> [Pixel] {
        let sample = self
        var pixelArray: [Pixel] = []
        if let cfData = sample.cgImage?.dataProvider?.data {
            let data = cfData as Data
            for i in stride(from: 0, to: data.count, by: 4) {
                let r = data[i]
                let g = data[i+1]
                let b = data[i+2]
                pixelArray.append(Pixel(r8: r, g8: g, b8: b))
            }
        }
        return pixelArray
    }
    ///Saves UIImage to "current" global variable in [Pixel representation]
    func cachePixels(){
        current.pixelList = self.displayToPixels()
    }
    
    /*
    private func getRGBatAddress(_ x: Int, _ y: Int) -> Pixel {
        let pixelAddress = x * 4 + y * width * 4
    }
    
    func iteratesImage(baseImage: UIImage?){
        //Ensure that image is present
        guard let bigImage = baseImage else {return}
        ///Tiny array to make iteration easier
        let image = compressImage(image: bigImage)
            let width = Int(image.size.width)
            let height = Int(image.size.height)
        //Instantiate local array for holding pixel color values
        var pixelArray: [UIColor] = []
            var red = 0, green = 0, blue = 0
        //Main logic: Iterate through pixel
            if let cfData = image.cgImage?.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
                for x in 0..<width {
                    for y in 0..<height {
                        let pixelAddress = x * 4 + y * width * 4
                        red = Int(pointer.advanced(by: pixelAddress).pointee)
                        green = Int(pointer.advanced(by: pixelAddress + 1).pointee)
                        blue = Int(pointer.advanced(by: pixelAddress + 2).pointee)
                        
                        ///Reassign to floats for color assignments
                        let redVal = CGFloat(red)
                        let greenVal = CGFloat(green)
                        let blueVal = CGFloat(blue)
                        ///Create totalcolor with removed opacity stuff
                        let totalColor = UIColor(red: redVal, green: greenVal, blue: blueVal, alpha: 1.0)
                        ///Add totalColor to local pixelArray
                        pixelArray.append(totalColor)
                        print("Appended \([redVal, greenVal, blueVal])")
                    }
                }//End outer for
                //Assign new working array of pixels to global reference
                CurrentPalette.pixelArray = pixelArray
            }
        }
 */

}
