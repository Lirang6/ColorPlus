//
//  GlobalStorage.swift
//  ImageTesterF
//  Contains static values used in K-means
//  Also contains user-input settings
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit

///Working storage for pixels and clusters
struct current {
    
    //size for compressing the image
    static var thumbSize = CGSize(width: 150, height: 150)
    
    ///Image for K-means analysis represented as array of Pixels. Set by loadPixels(IMG) or IMG.cachePixels.
    static var pixelList: [Pixel] = []
    
    static var imageBrightnessChange: CGFloat = 0
    static var imageContrastChange: CGFloat = 1
    static var imageSaturationChange: CGFloat = 1

    ///Desired number of colors on the palette.
    ///Optimized when equal to # of predicted colors in image, or 6 or 9
    static var totalColors: Int = 6
    
    ///Stores centroids & assigned pixels for K-Means. Will converge to most common colors.
    static var clusterList: [Cluster] = []
    
    ///Most common colors as array of UIColors.
    static var palette: [UIColor] = []
    
    ///Higher value = faster runtime but worse K-means precision. Range is 0-452.
    static var leeway: CGFloat = 0
    
    ///Compute palette in RGB Pixel format.
    static var paletteAsPixel: [Pixel] {
        var retColors: [Pixel] = []
        for color in palette {
            let asPixel = Pixel(UIColour: color)
            asPixel.roundSelf()
            retColors.append(asPixel)
        }
        return retColors
    }
    
    ///Compute palette in Hex format
    static var paletteAsHex: [String] {
        var retHex: [String] = []
        for color in paletteAsPixel {
            let asString = color.toHexString()
            retHex.append(asString)
        }
        return retHex
    }
}

/**
 Saves pixels of image selected to current.pixelList
 - Parameter image: Image to convert to pixels & store
 */
func loadPixels(image: UIImage) {
    image.cachePixels()
}
