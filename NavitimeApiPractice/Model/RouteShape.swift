//
//  RouteShape.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/10.
//

import Foundation


struct RouteShape: Codable{
    let items: [items]
}

struct items: Codable{
    let path: [path]
}

struct path: Codable{
    let coords: locationPoint
    let width: Int
    let color: String
    let opacity: Int
    let roadType: String
    
    enum CodingKeys: String, CodingKey{
        case coords
        case width
        case color
        case opacity
        case roadType = "road_type"
    }
}

struct locationPoint: Codable{
    let lat: Double
    let lon: Double
}

