//
//  NextViewController.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/06.
//

import UIKit
import Alamofire
import SwiftyJSON

class NextViewController: UIViewController {

    
    var startText = ""
    var goalText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getDirection(startAddress: startText, goalAddress: goalText)
        
    }
    
    private func getDirection(startAddress: String, goalAddress: String){
        
        let startBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?language=ja&address=\(startAddress)&key=AIzaSyApDu6UPk5wnwCAQLJrjnRaXMTk9hR94Vk"
        let startURL = startBaseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(startURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            do{
            let start:Geometry = try JSONDecoder().decode(Geometry.self, from: data)
                print(start)
                
                //到着地の緯度経度を取得
                let goalBaseURL = "https://maps.googleapis.com/maps/api/geocode/json?language=ja&address=\(goalAddress)&key=AIzaSyApDu6UPk5wnwCAQLJrjnRaXMTk9hR94Vk"
                let goalURL = goalBaseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
               
                AF.request(goalURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
                    
                    guard let data = response.data else {return}
                    do{
                        let goal:Geometry = try JSONDecoder().decode(Geometry.self, from: data)
                        print(goal)
                        
                        //Navitime API
                        
                        let headerContent = [
                            "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
                            "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
                        ]
                        let headers = HTTPHeaders.init(headerContent)
                        
                        let baseUrl = "https://navitime-route-car.p.rapidapi.com/route_car"
                        
                        guard var components = URLComponents(string: baseUrl), let startResults = start.results.first, let goalResults = goal.results.first else {return}
                        
                        components.queryItems = [
                        
                            URLQueryItem(name: "start", value: "\(startResults.geometry.location.lat),\(startResults.geometry.location.lng)"),
                            URLQueryItem(name: "goal", value: "\(goalResults.geometry.location.lat),\(goalResults.geometry.location.lng)"),
                            URLQueryItem(name: "options", value: "turn_by_turn"),
                            URLQueryItem(name: "start_time", value: "2021-01-04T10:00:00")
                        ]
                        
                        guard let url = components.url else {return}
                        print(url)
                        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                        
                           
                            guard let data = response.data else {return}
                            do{
                                let directions:Direction = try JSONDecoder().decode(Direction.self, from: data)
                                print(directions)
                            }catch{
                                print(error)
                            }
                        }
                    }catch{
                        print(error)}
                
                }
            }catch{
                print(error)
                    }
        }
    }
}
