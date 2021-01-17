//
//  SearchResultModel.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/10.
//

import Foundation
import Alamofire
import GoogleMaps
import GooglePlaces

class SearchResultModel{
    
    let geometryAPI = GeometryAPI()
    let navitimeAPI = NavitimeAPI()
    
    var highwayMarkerList = [highwayMarker]()
    
    struct highwayMarker{
        var title: String
        var lat: Double
        var lng: Double
        
        init(name:String, lat:Double, lon:Double) {
            self.title = name
            self.lat = lat
            self.lng = lon
        }
    }
    
    struct Places{
        
        var startLat: Double
        var startLng: Double
        var goalLat: Double
        var goalLng: Double
    
        var startAddress: String
        var goalAddress: String
        
    }
    
    
    func getPath(startAddress: String, goalAddress: String, mapView:GMSMapView){
        
        let routePath = GMSMutablePath()
        let polyLine = GMSPolyline()
        
        geometryAPI.getGeometry(address: startAddress) { [self] (geometry) in
            if let geometry = geometry{
                guard let results = geometry.results.first else {return}
                let startLat = results.geometry.location.lat
                let startLng = results.geometry.location.lng
                print(startLat, startLng)
                
                geometryAPI.getGeometry(address: goalAddress) { (geometry) in
                    if let geometry = geometry{
                        guard let results = geometry.results.first else {return}
                        let goalLat = results.geometry.location.lat
                        let goalLng = results.geometry.location.lng
                        print(goalLat, goalLng)
                        
                        let places = Places(startLat: startLat, startLng: startLng, goalLat: goalLat, goalLng: goalLng, startAddress: startAddress, goalAddress: goalAddress)
                        
                    //経路の各地点を取得する
                    navitimeAPI.getRouteShape(startLat: places.startLat, startLng: places.startLng, goalLat: places.goalLat, goalLng: places.goalLng) { (routeShape) in
                                        if let routeShape = routeShape{
                                            
                                            guard let items = routeShape.items.first else {return}
                                                //path内の曲がる座標を線で結んでいく
                                                for path in items.path {
                                                    for i in 0...path.coords.count-1 {
                                                        routePath.add(CLLocationCoordinate2D(latitude: path.coords[i][0], longitude: path.coords[i][1]))
                                                        }
                                                }

                                            //Map上に表示
                                            polyLine.path = routePath
                                            polyLine.strokeWidth = 4.0
                                            polyLine.map = mapView
                                        }
                                    }
                        //縮尺調整
                        updateCameraZoom(mapView: mapView, startLat: places.startLat, startLng: places.startLng, goalLat: places.goalLat, goalLng: places.goalLng)

                        //出発地、到着地にピンを立てる
                        addMarker(lat: places.startLat, lng: places.startLng, title: places.startAddress, mapView: mapView)
                        addMarker(lat: places.goalLat, lng: places.goalLng, title: places.goalAddress, mapView: mapView)
                        
                        //高速道路の記載があるところにピンを立てる
                        //高速道路がある場所の名称と緯度経度を取得
                        navitimeAPI.getDirection(startLat: startLat, startLng: startLng, goalLat: goalLat, goalLng: goalLng) {(direction) in
                            if let direction = direction{
                                guard let items = direction.items.first else {return}
                                let sections = items.sections
                                for i in 0..<sections.count{
                                    if sections[i].highway != nil{
                                        addMarker(lat: sections[i].coord.lat, lng: sections[i].coord.lon, title: sections[i].name, mapView: mapView)
                                    }
                                }
                            }
                        }
                        
                    }
            }
                
            }
        }
        
        
    }
    
    func getHighwayMarkerInfo(startAddress: String, goalAddress: String, startLat: Double, startLng: Double, goalLat: Double, goalLng: Double, mapView: GMSMapView){
    
        //高速道路がある場所の名称と緯度経度を取得
        navitimeAPI.getDirection(startLat: startLat, startLng: startLng, goalLat: goalLat, goalLng: goalLng) {(direction) in
            if let direction = direction{
                self.highwayMarkerList.removeAll()
                guard let items = direction.items.first else {return}
                let sections = items.sections
                for i in 0..<sections.count{
                    if sections[i].highway != nil{
                        self.addMarker(lat: sections[i].coord.lat, lng: sections[i].coord.lat, title: sections[i].name, mapView: mapView)
                    }
                }
            }
        }
    }
    
    //カメラの縮尺調整
    func updateCameraZoom(mapView:GMSMapView, startLat: Double, startLng: Double, goalLat: Double, goalLng: Double) {
           
           let startCoordinate = CLLocationCoordinate2D(latitude: startLat, longitude: startLng)
           let endCoordinate = CLLocationCoordinate2D(latitude: goalLat, longitude: goalLng)
           let bounds = GMSCoordinateBounds(coordinate: startCoordinate, coordinate: endCoordinate)
           let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
           mapView.moveCamera(cameraUpdate)
       }
    //ピンを立てる
        func addMarker (lat: Double, lng: Double, title:String, mapView:GMSMapView){
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = title
        marker.map = mapView
        
    }
}
