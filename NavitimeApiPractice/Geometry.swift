//
//  startGeometry.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/06.
//

import Foundation

struct Geometry: Codable{
    let results: [results]
}

struct results: Codable{
    let geometry : geometry
}

struct geometry: Codable{
    let location: location
}

struct location: Codable{
    let lat: Double
    let lng: Double
}
