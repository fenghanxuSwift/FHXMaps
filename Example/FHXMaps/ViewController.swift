//
//  ViewController.swift
//  FHXMaps
//
//  Created by fenghanxu on 10/22/2018.
//  Copyright (c) 2018 fenghanxu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FHXMaps

class ViewController: UIViewController {
  
  let mapView = SearchMapView()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.white      
      view.addSubview(mapView)
      mapView.frame = view.bounds
      mapView.locationCallBlock = { (_ location:CLLocationCoordinate2D) -> () in
        print("latitude = \(location.latitude)")
        print("longitude = \(location.longitude)")
      }
      mapView.messageCallBlock = { (_ message:MKMapItem) -> () in
        print("name = \(String(describing: message.name))")
        print("name = \(message.placemark.coordinate)")
      }
    }

}

//LocationManager
/*
 //获取经纬度,地址
 LocationManager.shareManager.creatLocationManager().startLocation { (location, address, error) in
 print("经度 \(location?.coordinate.longitude ?? 0.0)")
 print("纬度 \(location?.coordinate.latitude ?? 0.0)")
 print("地址\(address ?? "")")
 print("error\(error ?? "没有错误")")
 
 }
 
 //地理编码:通过地址获取经纬度
 LocationManager.shareManager.geocoderClick(address: "广东省佛山市顺德区广珠公路") { (location) in
 print("经度,纬度\(location?.coordinate.latitude, location?.coordinate.longitude)")
 }
 
 //反地理编码:通过经纬度获取地址
 LocationManager.shareManager.reverceGeocoderClick(latitude: 22.755849000000001, longitude: 113.275504) { (adress) in
 print("adress = \(String(describing: adress))")
 }
 
 //CLLocationCoordinate2D 转 CLLocation
 var curAddressCoordinate = CLLocationCoordinate2D()
 curAddressCoordinate.latitude = 113.150783619017
 curAddressCoordinate.longitude = 22.8123897593681
 let cllocation_0 = LocationManager.shareManager.constructWithCLLocation(coordinate: curAddressCoordinate)
 print("cllocation = \(cllocation_0)")
 
 //CLLocation 转 CLLocationCoordinate2D
 let cllocation_1 = CLLocation(latitude: 113.150783619017, longitude: 22.8123897593681)
 let location = LocationManager.shareManager.constructWithCLLocationCoordinate2D(loaction: cllocation_1)
 print("location = \(location)")
 
 }
 */

//MapShowPosition
/*
 let mapView = IOSMapView()
 view.addSubview(mapView)
 mapView.frame = view.bounds
 mapView.locationCallBlock = {(_ location:CLLocationCoordinate2D) -> () in
 print("location.latitude = \(location.latitude)")
 print("location.longitude = \(location.longitude)")
 }
 */

//SearchMap
/*
 let mapView = SearchMapView()
 view.addSubview(mapView)
 mapView.frame = view.bounds
 mapView.locationCallBlock = { (_ location:CLLocationCoordinate2D) -> () in
 print("latitude = \(location.latitude)")
 print("longitude = \(location.longitude)")
 }
 mapView.messageCallBlock = { (_ message:MKMapItem) -> () in
 print("name = \(String(describing: message.name))")
 print("name = \(message.placemark.coordinate)")
 }
 */



