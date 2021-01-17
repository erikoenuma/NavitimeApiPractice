//
//  SearchResultView.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/08.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces


class SearchResultView: UIView{

    let mapView = GMSMapView()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(mapView)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = self.frame
        mapView.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    }
}
