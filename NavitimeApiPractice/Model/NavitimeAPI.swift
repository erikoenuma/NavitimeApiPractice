//
//  NavitimeAPI.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/07.
//

import Foundation
import Alamofire

class NavitimeAPI{
    
    var startLat: Double = 0.0
    var startLng: Double = 0.0
    var goalLat: Double = 0.0
    var goalLng: Double = 0.0
    
    //GeometryAPIから出発地の緯度経度を受け取る
    func setStartGeometry(lat: Double, lng: Double){
        self.startLat = lat
        self.startLng = lng
    }
    
    //GeometryAPIから到着地の緯度経度を受け取る
    func setGoalGeometry(lat: Double, lng: Double){
        self.goalLat = lat
        self.goalLng = lng
    }
    
    let headerContent = [
        "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
        "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
    ]
    
    private func getRouteShape(completion: @escaping((RouteShape) -> Void)){
        
        //headerの設定をする
        let headers = HTTPHeaders.init(headerContent)
        
        let baseUrl = "https://navitime-route-car.p.rapidapi.com/shape_car"
        
        //URLクエリの内容を指定する
        guard var components = URLComponents(string: baseUrl) else {return}
        components.queryItems = [
        
            //出発地
            URLQueryItem(name: "start", value: "\(startLat),\(startLng)"),
            //到着地
            URLQueryItem(name: "goal", value: "\(goalLat),\(goalLng)"),
            //交差点等、進行情報を案内するための地点情報
            URLQueryItem(name: "options", value: "turn_by_turn"),
            //出発時間
            URLQueryItem(name: "start_time", value: "2021-01-04T10:00:00"),
            //JSONで出力
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {return}
        print(url)
        
        //API通信
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {(response) in
           
            guard let data = response.data else {return}
            do{
                let routeShape:RouteShape = try JSONDecoder().decode(RouteShape.self, from: data)
                print(routeShape)
                completion(routeShape)
                
            }catch{
                print(error)
            }
    }
}
    
    private func getDirection(completion: @escaping((Direction)-> Void)){
        
        //headerの設定をする
        let headers = HTTPHeaders.init(headerContent)
        
        let baseUrl = "https://navitime-route-car.p.rapidapi.com/route_car"
        
        //URLクエリの内容を指定する
        guard var components = URLComponents(string: baseUrl) else {return}
        components.queryItems = [
        
            //出発地
            URLQueryItem(name: "start", value: "\(startLat),\(startLng)"),
            //到着地
            URLQueryItem(name: "goal", value: "\(goalLat),\(goalLng)"),
            //交差点等、進行情報を案内するための地点情報
            URLQueryItem(name: "options", value: "turn_by_turn"),
            //出発時間
            URLQueryItem(name: "start_time", value: "2021-01-04T10:00:00"),
            
        ]
        
        guard let url = components.url else {return}
        print(url)
        
        //API通信
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {(response) in
           
            guard let data = response.data else {return}
            do{
                let directions:Direction = try JSONDecoder().decode(Direction.self, from: data)
                print(directions)
                completion(directions)
                
            }catch{
                print(error)
            }
    }
        
    }
}
