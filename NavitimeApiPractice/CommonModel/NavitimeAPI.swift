//
//  NavitimeAPI.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/07.
//

import Foundation
import Alamofire

class NavitimeAPI{
    
    let headerContent = [
        "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
        "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
    ]
    
    func getRouteShape(startLat: Double, startLng: Double, goalLat: Double, goalLng: Double, completion: @escaping((RouteShape?) -> Void)){
        
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
        
//        guard let url = components.url else {return}
//        print(url)
//
        
        let baseurl = "https://navitime-route-car.p.rapidapi.com/shape_car?start=35.6284713,139.7387597&goal=35.4436739,139.6379639&options=turn_by_turn&start_time=2021-01-04T10:00:00&format=json"
        let url = baseurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
    
    func getDirection(startLat: Double, startLng: Double, goalLat: Double, goalLng: Double, completion: @escaping((Direction?)-> Void)){
        
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
