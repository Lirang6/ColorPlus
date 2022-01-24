//
//  Cluster.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit


class Cluster: CustomStringConvertible {
    var centroid: Pixel
    var assignedPixels: [Pixel]
    var recentMove: CGFloat = 442
    
    var description: String {
        var toPrint = ""
        toPrint = "Cstr:\(centroid) INCLUDES{"
        for pix in assignedPixels {
            toPrint += pix.description
        } //Iterate through all contained in assigned
        toPrint += "}" //Cap
        return toPrint
    }
    
    init(newCenter: Pixel) {
        self.centroid = newCenter
        self.assignedPixels = []
    }
    convenience init(newUICenter: UIColor) {
        self.init(newCenter: Pixel(UIColour: newUICenter))
    }
    ///Initialize "blank" cluster
    convenience init(){
        let centroid = Pixel(r: 254, g: 254, b: 254)
        self.init(newCenter: centroid)
    }
    
    ///Add a pixel to the cluster
    func assign(px: Pixel){
        self.assignedPixels.append(px)
    }
    ///Add a UIColor to the cluster
    func assign(UIColour: UIColor){
        let px = Pixel(UIColour: UIColour)
        self.assignedPixels.append(px)
    }
    ///Set centroid to reflect assigned pixel center
    func updateCenter(){
        //Save old centroid location temporarily
        let oldCentroid = self.centroid
        //Create NEW centroid from assigned pixels
        self.centroid = getCentroid()
        //Change recentMove value to reflect distance travelled
        self.recentMove = oldCentroid.distanceFromPixel(otherPixel: self.centroid)
        //Reset assigned pixels
        self.assignedPixels = []
    }
    ///Get centroid from assigned pixels
    func getCentroid() -> Pixel{
        //Value to return if nothing found... Note: May be used as seed pixel later. Be careful.
        let nullPixel = Pixel(UIColour: UIColor.black)
        //Grab pixels once for fast data access
        let closePixels = self.assignedPixels
        //Exit function if no pixels found.
        if closePixels.count < 1 {return nullPixel}
        //Create holder RGB values
        var avgRed: CGFloat = 0, avgGreen: CGFloat = 0, avgBlue: CGFloat = 0
        //Count total
        var count: Int = 0
        
        for pixel in closePixels {
            avgRed += pixel.r
            avgGreen += pixel.g
            avgBlue += pixel.b
            count += 1
        }
        let total = CGFloat(count)
        //New centroid given the assigned pixels
        let newCentroid = Pixel(r: avgRed/total, g: avgGreen/total, b: avgBlue/total)
        return newCentroid
    }
    
    
    ///Start with RANDOM color centroid
    
    
    ///A new cluster with random coordinates

    
    
}
