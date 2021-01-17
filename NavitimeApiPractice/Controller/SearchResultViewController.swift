//
//  SearchResultViewController.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/08.
//

import UIKit
import GoogleMaps
import GooglePlaces


class SearchResultViewController: UIViewController{
    
    var startName: String = ""
    var goalName: String = ""
    
    
    override func loadView() {
        self.view = SearchResultView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchResultView = self.view as! SearchResultView
        let mapView = searchResultView.mapView
       
        
        let searchResultModel = SearchResultModel()
        searchResultModel.getPath(startAddress: startName, goalAddress: goalName, mapView: mapView)
        
        
        }

}
    
   
