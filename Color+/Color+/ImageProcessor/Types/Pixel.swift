//
//  Pixel.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/20/21.
//

import Foundation
import UIKit

class Pixel: CustomStringConvertible {
    ///Value of red for this pixel
    var r, g, b: CGFloat
    let a: CGFloat = 1.0
    var rgb: [CGFloat] {return [r,g,b]}
    var color: UIColor {return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)}
    
    var description : String {
        let toPrint = [r, g, b]
        return "\(toPrint)"
    }
    
    ///Basic initializer given 3 CGFloats
    init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.r = validRGB(r)
        self.g = validRGB(g)
        self.b = validRGB(b)
    }
    ///Initializer given 1 near-Pixel
    convenience init(rgb: [CGFloat]){
        if rgb.count > 2 {
            self.init(r: rgb[0], g: rgb[1], b: rgb[2])
        }else{
            self.init(r: 0, g: 0, b: 66)
        }
    }
    ///Return a new clone of old pixel
    convenience init(toClone: Pixel){
        self.init(r: toClone.r, g: toClone.g, b: toClone.b)
    }
    ///Create new Pixel from Int values
    convenience init(rInt: Int, gInt: Int, bInt: Int){
        self.init(r: CGFloat(rInt), g: CGFloat(gInt), b: CGFloat(bInt))
    }
    ///Create new Pixel from UInt8Values
    convenience init(r8: UInt8, g8: UInt8, b8: UInt8){
        self.init(r: CGFloat(r8), g: CGFloat(g8), b: CGFloat(b8))
    }
    ///Create new Pixel from UIColor
    convenience init(UIColour: UIColor){
        self.init(r: UIColour.RED, g: UIColour.GREEN, b: UIColour.BLUE)
    }
    ///Create new Pixel with random or white value
    convenience init(isRandom: Bool){
        switch isRandom{
        //If not random, create default white pixel
        case false: self.init(r: 255, g: 255, b: 255)
        //Otherwise, create random RGB pixel
        case true: self.init(rgb: [CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256)), CGFloat(arc4random_uniform(256))])
        }
    }
    
    ///Return Euclidean distance from Pixel as CGFloat
    func distanceFromPixel(otherPixel: Pixel) -> CGFloat {
        let rDist = otherPixel.r - self.r
        let gDist = otherPixel.g - self.g
        let bDist = otherPixel.b - self.b
        
        ///Accumulated difference
        let squaredDistance = rDist*rDist + gDist*gDist + bDist*bDist
        return sqrt(squaredDistance)
    }
    
    ///Return Euclidean distance from Cluster as CGFloat
    private func distanceFromCluster(cluster: Cluster) -> CGFloat {
        let otherPixel = cluster.centroid
        return distanceFromPixel(otherPixel: otherPixel)
    }
    ///Return INDEX of Closest Cluster from array of [Cluster]
    private func closestCluster(clusterList: [Cluster]) -> Int {
        var minDist: CGFloat = 390
//        var minDist: CGFloat = 442 //Max theoretical difference
        var minIndex: Int = 0 //Within bounds no matter what
        
        //Enumerate over list of Clusters
        for (clustOffset, clustElement) in clusterList.enumerated() {
            let newDist = self.distanceFromCluster(cluster: clustElement)
            if newDist < minDist {
                minDist = newDist
                minIndex = clustOffset
            }
        }
        return minIndex
    }
    ///Assign THIS PIXEL to closest cluster
    func assignClosest() {
        //Get index of closest of current clusters
        let bestIndex = closestCluster(clusterList: current.clusterList)
        //Assign pixel to clusterList
        current.clusterList[bestIndex].assignedPixels.append(self)
    }

    
    ///Randomize the RGB values of this cluster
    func randomize(){
        self.r = CGFloat(arc4random_uniform(256))
        self.g = CGFloat(arc4random_uniform(256))
        self.b = CGFloat(arc4random_uniform(256))
    }
    
    ///Rounds this pixel to an integer value
    func roundSelf(){
        self.r = validRGB(self.r.rounded())
        self.g = validRGB(self.g.rounded())
        self.b = validRGB(self.b.rounded())
    }
    
    ///Create hexcode from pixel
    func toHexString() -> String {
        let rgb:Int = (Int)(self.r)<<16 | (Int)(self.g)<<8 | (Int)(self.b)<<0
        let retString = NSString(format:"#%06x", rgb) as String
        return retString
    }
}

