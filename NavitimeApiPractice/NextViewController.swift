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

        getDirection()
        
    }
    
    private func getDirection(){
        
        let headerContent = [
            "x-rapidapi-host": "navitime-route-car.p.rapidapi.com",
            "x-rapidapi-key": "d058e7a572msh65b2857f9c8bdf7p1f1fe3jsne067d62882cb"
        ]
        
        let headers = HTTPHeaders.init(headerContent)

        let url = "https://navitime-route-car.p.rapidapi.com/route_car?start=35.689457,139.691935&goal=00007423&condition=toll_time&start_time=2019-10-01T08:00:00&options=turn_by_turn"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
        
    }

}
