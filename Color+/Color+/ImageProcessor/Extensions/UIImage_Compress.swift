//
//  UIImage_Compress.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit
import ImageIO

//Let's not bother with this for now...


extension UIImage {
    func imageByScaling(image: UIImage, toSize size: CGSize) -> UIImage? {
        let currentSize = image.size
        
        let widthRatio  = size.width  / currentSize.width
        let heightRatio = size.height / currentSize.height
        
        // Figure out what our orientation is
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: currentSize.width * heightRatio, height: currentSize.height * heightRatio)
        } else {
            newSize = CGSize(width: currentSize.width * widthRatio, height: currentSize.height * widthRatio)
        }
        
        let container = CGRect(origin: .zero, size: newSize)
           
           UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
           image.draw(in: container)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
        
        return newImage
}

}


