//
//  GeometryAPI.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/07.
//

import Foundation
import Alamofire

class GeometryAPI{
    
    var startAddress: String?
    var goalAddress: String?
    
    //SearchViewController層から値を受け取る
    func setAddress(startAddress: String, goalAddress: String){
        
        self.startAddress = startAddress
        self.goalAddress = goalAddress
        print(startAddress, goalAddress)
        
//        passGeometry(startAddress: startAddress, goalAddress: goalAddress)
        
    }
    
//    //SearchResultModelに出発地、到着地の緯度経度を渡す
//    func passGeometry(startAddress: String, goalAddress: String){
//
//        //出発地の緯度経度を渡す
//        getGeometry(address: startAddress) { [self] (geometry) in
//            if let geometry = geometry{
//                guard let results = geometry.results.first else {return}
//                searchResultModel.setStartGeometry(lat: results.geometry.location.lat, lng: results.geometry.location.lng)
//            }
//        }
//
//        //到着地の緯度経度を渡す
//        getGeometry(address: goalAddress) { [self] (geometry) in
//            if let geometry = geometry{
//                guard let results = geometry.results.first else {return}
//                searchResultModel.setGoalGeometry(lat: results.geometry.location.lat, lng: results.geometry.location.lng)
//            }
//        }
//
//        }
//
//    }
    
     //出発地・到着地の緯度経度、地点名を取得
     func getGeometry(address: String, completion:@escaping((Geometry?) -> Void)){
        
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?language=ja&address=\(address)&key=AIzaSyApDu6UPk5wnwCAQLJrjnRaXMTk9hR94Vk"
        let url = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            do{
            let geometry:Geometry = try JSONDecoder().decode(Geometry.self, from: data)
                print(geometry)
                completion(geometry)
                
            }catch{
                print(error)
            }
        }
        
    }
}
