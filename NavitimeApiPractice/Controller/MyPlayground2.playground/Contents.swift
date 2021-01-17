import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class NavitimeAPI{
    
    let headerContent = [
        "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
        "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
    ]
    
    func getRouteShape(startLat: Double, startLng: Double, goalLat: Double, goalLng: Double){
        
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
        
//        let baseurl = "https://navitime-route-car.p.rapidapi.com/shape_car?start=35.6284713,139.7387597&goal=35.4436739,139.6379639&options=turn_by_turn&start_time=2021-01-04T10:00:00&format=json"
//        let url = baseurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //API通信
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {(response) in
            
//            switch response.result {
//            case .success:
//                let json:JSON = JSON(response.data as Any)
//                print(json)
//            case .failure(let error):
//                print(error)
//            }
           
            guard let data = response.data else {return}
            do{
                let routeShape:RouteShape = try JSONDecoder().decode(RouteShape.self, from: data)
                print(routeShape)

            }catch{
                print(error)
            }
    }
}
}

struct RouteShape: Codable{
    var items: [items]
}

struct items: Codable{
    let path: [path]
}

struct path: Codable{
    
    let coords: [[Double]]
    let width: Int
    let color: String
    let opacity: Double
    let roadType: String!
    
    enum CodingKeys: String,CodingKey{
        case coords
        case width
        case color
        case opacity
        case roadType = "road_type"
    }
}


let navitimeAPI = NavitimeAPI()
navitimeAPI.getRouteShape(startLat: 35.6284713, startLng: 139.7387597, goalLat: 35.4436739, goalLng: 139.6379639)


