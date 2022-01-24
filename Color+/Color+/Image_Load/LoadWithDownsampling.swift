//
//  LoadWithDownsampling.swift
//  Color+
//
//  Created by Steven Angtuaco on 11/24/21.
//

import Foundation
import UIKit
import ImageIO //Feel free to use another framework if it works better!

/**
 Creates a downsampled UIImage from downsampled data loaded from the specific URL.
 - Parameter url: URL specifying path to the photo gallery
 - Returns: Doesn't return, but saves resultant UIImage to CurrentPalette.image
 */
func loadFromURL(url: URL){
    //TODO: Generate downsampled data from file path (URL), convert to UIImage, save to CurrentPalette.image
    ///Implement helper function
    guard urlFromPicker() != nil else {return}
    //let downsampledJPEGData = Data(contentsOf: urlOfPicture)
    //guard let imageToLoad = UIImage(data: downsampledJPEGData) else {return}
    //CurrentPalette.image = imageToLoad
}

/**
 Calls the photo gallery picker & generates URL based on user selection.
 - Returns: Object specifying filepath to Photo Gallery image
 */
func urlFromPicker() -> URL? {
    ///Save picker filepath to me!
    let filepath: String = ""
    
    //TODO: Assign filepath to "filepath" using photo picker. Safely unwrap & ensure link is valid.
    
    ///URL object from filepath
    let urlToSelected = URL(fileURLWithPath: filepath)
    return urlToSelected
}
