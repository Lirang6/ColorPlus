//
//  KMeans.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/24/21.
//

import Foundation
import UIKit
import CoreImage

func kMeans(){
    //Safe start:
    let numClusters = current.clusterList.count
    let numPixels = current.pixelList.count
    var maxAllowedMove = current.leeway
    
    if numClusters < 6 {
        //Create blank slate of clusters if somehow not already done
        initializeClusters()
    }
    if numPixels < 1 {
        //End if no pixels have been loaded
        print("No pixels found!")
        return
    }
    if current.leeway == 0 {
        maxAllowedMove = 0.01
    }
    
    ///Distance moved in the last iteration of kMeans
    var distanceMoved = CGFloat(442 * numClusters)
    var totalIterations = 0
    
    //Repeat K-Means until clusters stop moving.
    repeat {
        //One iteration of Kmeans performed by the helper
        distanceMoved = kMeansHelper()
        totalIterations += 1
//        print("After \(totalIterations), moved \(distanceMoved)")
    } while distanceMoved > maxAllowedMove
    
    //Save K-means'ed colors to current.palette
    assignColors()
    //Print number of runs
//    print(totalIterations)
}

/**
 One iteration of K-Means, using the values stored in current.
 - Returns: Distance moved.
 */
private func kMeansHelper() -> CGFloat {
    var distanceMoved: CGFloat = 0.0
    
    //Define working variables
    let pixels = current.pixelList
    
    //Assign each pixel to its closest cluster
    for pixel in pixels {
        pixel.assignClosest()
    }
    
    //Move clusters depending on assigned pixels.
    for cluster in current.clusterList {
        //Takes average of assigned pixels, moves centroid, captures distance, and then purges cluster of assigned pixels
        cluster.updateCenter()
        
        //Increase distance based on how much was moved
        distanceMoved += cluster.recentMove
    }
    
    //Return total distanced moved in this iteration
    return distanceMoved
}

///Sets current.palette = to colors of last Kmeans
private func assignColors() {
    //Compute UIColors
    var allUIColors: [UIColor] {
        var allCentroids: [UIColor] = []
        //Iterate over all working clusters
        //sorts colors so they are asethically pleasing on the palette
        current.clusterList.sort(by: {$0.centroid.r > $1.centroid.r})
        for cluster in current.clusterList {
            let centerPixel = cluster.centroid
            
//            print("center pixel \(centerPixel)")
            let thisColor = UIColor(red: centerPixel.b/255, green: centerPixel.g/255, blue: centerPixel.r/255, alpha: centerPixel.a/255)
            allCentroids.append(thisColor)
            //Append the cluster to the internal list
        }
        //Return all centroids of Clusters as UiColors
        return allCentroids
    }
//    print("all uicolors \(allUIColors)")
    print("cluster list \(current.clusterList)")
    //Set palette = to harvested values
    current.palette = allUIColors
}




///Creates an array of 6+ clusters for use with K-Means
func initializeClusters(){
    //Number of colors wanted by the array
    let colorsWanted = current.totalColors
    //1st row: Color clusters
    let red = Cluster(newCenter: Pixel(r: 255, g: 0, b: 0))
    let green = Cluster(newCenter: Pixel(r: 0, g: 255, b: 0))
    let blue = Cluster(newCenter: Pixel(r: 0, g: 0, b: 255))
    //2nd row: Opposing clusters
    let cyan = Cluster(newCenter: Pixel(r: 0, g: 255, b: 255))
    let magenta = Cluster(newCenter: Pixel(r: 255, g: 0, b: 255))
    let yellow = Cluster(newCenter: Pixel(r: 255, g: 255, b: 0))
    //3rd row? Brightness clusters
    let black = Cluster(newUICenter: UIColor.black)
    let gray = Cluster(newUICenter: UIColor.gray)
    let white = Cluster(newUICenter: UIColor.white)
    
    ///Cluster list to return
    var returnClusters: [Cluster] = [red, green, blue, white, gray, black, cyan, magenta, yellow]
    
    //If desired number of clusters exceeds 9, add bonus clusters
    let extraClustsNeeded = colorsWanted - returnClusters.count
    
    if extraClustsNeeded > 0 {
        //Create # of clusters equal to extra
        let spares = createRandomClusters(clustersNeeded: extraClustsNeeded)
        returnClusters += spares
    }else if extraClustsNeeded < 0 {
        //Drop # of clusters equal to extra
        returnClusters = returnClusters.dropLast(abs(extraClustsNeeded))
    }
    
    ///Save new list to clusterList
    current.clusterList = returnClusters
}

