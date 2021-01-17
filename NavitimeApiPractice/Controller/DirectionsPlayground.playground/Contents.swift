import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class NavitimeAPI{
    
    let headerContent = [
        "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
        "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
    ]
    
    func getDirection(startLat: Double, startLng: Double, goalLat: Double, goalLng: Double){
        
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
            //有料無料全て利用
            URLQueryItem(name: "road_type", value: "any")
            
        ]
        
        guard let url = components.url else {return}
        print(url)
        
        //API通信
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {(response) in
           
            guard let data = response.data else {return}
            do{
                let directions:Direction = try JSONDecoder().decode(Direction.self, from: data)
                print(directions)
            }catch{
                print(error)
            }

//            switch response.result {
//            case .success:
//                let json:JSON = JSON(response.data as Any)
//                print(json)
//            case .failure(let error):
//                print(error)
//            }
    }
        
    }
}

struct Direction: Codable{
    let items: [Items]
}

struct Items: Codable{
    let summary: Summary
    let sections: [Sections]
    let fares: [Fares]
}

struct Sections: Codable{
    //道路か地点か
    let type: String!
    //経路の座標
    let coord: LocationPoint!
    //地点名称
    let name: String!
    //道路名称
    let lineName: String!
    //地点間の距離(m)
    let distance: Int!
    //地点間の所要時間(分)
    let time: Int!
    //出発時間
    let fromTime: String!
    //到着時間
    let toTime: String!
    //移動手段
    let move: String!
    //高速道路
    let highway: String!
    //右回りに16分割した角度
    let direction: Int!
    
    enum CodingKeys: String,CodingKey{
        
        case type
        case coord
        case name
        case lineName = "line_name"
        case distance
        case time
        case fromTime = "from_time"
        case toTime = "to_time"
        case move
        case highway
        case direction
        
    }
}

struct Summary: Codable{
    
    //ルート結果内番号
    let number: String
    //出発地点に関する情報
    let start: TypePoint
    //到着地点に関する情報
    let goal: TypePoint
    //移動情報
    let move: Move
    //経由地に関する情報
    let via: [TypePoint]!
    
    enum CodingKeys: String, CodingKey{
        case move
        case start
        case number = "no"
        case goal
        case via
    }
}

struct TypePoint: Codable{
    //type
    let type: String
    //緯度経度
    let coord: LocationPoint
    //地点名(start/goal)
    let name: String
    //経由地出発時間
    let fromTime: String!
    //経由地到着時間
    let toTime: String!
    
    enum CodingKeys: String, CodingKey{
        case type
        case coord
        case name
        case fromTime = "from_time"
        case toTime = "to_time"
    }
}

struct Move: Codable{
    
    //出発時刻
    let fromTime :String
    //総距離(m)
    let distance: Int
    //総時間（分）
    let time: Int
    //到着時刻
    let toTime: String
    //運賃
    let fare: Fare
    //タクシー運賃
    let otherFare: OtherFare
    //type
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case fromTime = "from_time"
        case distance
        case time
        case toTime = "to_time"
        case fare
        case otherFare = "other_fare"
        case type
    }
}

struct Fares: Codable{
    
    let type: String!
    let coord: LocationPoint!
    let name: String!
    let detail: Detail!
    let fromTime: String!
    let toTime: String!
    let time: Int!
    let lineName: String!
    
    enum CodingKeys: String, CodingKey{
        case type
        case coord
        case name
        case detail
        case fromTime = "from_time"
        case toTime = "to_time"
        case time
        case lineName = "line_name"
    }
}

struct Detail: Codable{
    //料金シーズン
    let fareSeason: String
    //料金
    let fare: Fare
    
    enum CodingKeys: String, CodingKey{
        case fareSeason = "fare_season"
        case fare
    }
}

struct Fare: Codable{
    
    //軽自動車（現金）
    let lightCash: Double
    //軽自動車（ETC）
    let lightETC: Double
    //普通自動車（現金）
    let standardCash: Double
    //普通自動車（ETC）
    let standardETC: Double
    //中型車(現金）
    let mediumCash: Double
    //中型車(ETC）
    let mediumETC: Double
    //大型車(現金）
    let largeCash: Double
    //大型車（ETC）
    let largeETC: Double
    //特大車(現金）
    let extraLargeCash: Double
    //特大車(ETC）
    let extraLargeETC: Double
    
    enum CodingKeys: String, CodingKey{
        
        case lightCash = "unit_1024_1"
        case lightETC = "unit_1025_1"
        case standardCash = "unit_1024_2"
        case standardETC = "unit_1025_2"
        case mediumCash = "unit_1024_3"
        case mediumETC = "unit_1025_3"
        case largeCash = "unit_1024_4"
        case largeETC = "unit_1025_4"
        case extraLargeCash = "unit_1024_5"
        case extraLargeETC = "unit_1025_5"
    }
}

struct OtherFare: Codable{
    let taxi: Int
}

struct LocationPoint: Codable{
    let lon: Double
    let lat: Double
}


let navitimeAPI = NavitimeAPI()
navitimeAPI.getDirection(startLat: 35.6284713, startLng: 139.7387597, goalLat: 35.4436739, goalLng: 139.6379639)
