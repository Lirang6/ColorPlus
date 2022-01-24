//
//  ClusterList Helper.swift
//  ImageTesterF
//
//  Created by Steven Angtuaco on 11/24/21.
//

import Foundation
import UIKit

/*
func initializeClusters(){
    //Create array of random clusters of # totalColor
    var starterClusts: [Cluster] {
        var returnClusts: [Cluster] = []
        let totalCols = current.totalColors
        for _ in 0..<totalCols {
            let newClust = Cluster()
            newClust.centroid.randomize()
            returnClusts.append(newClust)
        }
        return returnClusts
    }
    current.clusterList = starterClusts
}
 */

//Helper functions
func randomizeClusters(){
    for cluster in current.clusterList {
        cluster.centroid.randomize()
    }
}

///If negative, set to zero
func positivize(int: Int) -> Int {
    if int < 0 {
        return 0
    }
    return int
}

/**
 Creates an array of randomized clusters. For use in baseClusters()
 - Parameter clustersNeeded: Number of random clusters to create.
 - Returns: A list of random clusters of length = clustersNeeded.
 */
func createRandomClusters(clustersNeeded: Int) -> [Cluster] {
    if clustersNeeded < 1 {
        return []
    }
    ///Increments downward as clusters are generated
    var extrasNeeded = clustersNeeded
    ///Storage for new clusters
    var returnClusts: [Cluster] = []
    repeat {
        let newClust = Cluster()
        newClust.centroid.randomize()
        returnClusts.append(newClust)
        extrasNeeded -= 1
    } while extrasNeeded > 0
    return returnClusts
}
