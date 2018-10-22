//
//  LocationManager.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/19.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

//地理编码:把地名转换成经纬度,可能会出现一对多的情况;

//反地理编码---经纬度变成地址

import UIKit
import CoreLocation

public class LocationManager: NSObject {
  //返回经纬度  地址  错误信息
  public typealias locationCallBack = (_ curLocation:CLLocation?, _ curAddress:String?, _ errorReason:String?)->()
  //返回经纬度
  public typealias returnLocation = (_ location:CLLocation?) -> ()
  //返回地址
  public typealias returnAdress = (_ address:String?) -> ()
  //MARK:-属性
  ///单例,唯一调用方法
  public static let shareManager =  LocationManager()
  private override init() {}
  var manager:CLLocationManager?
  //当前坐标
  var curLocation: CLLocation?
  //当前选中位置的坐标
  var curAddressCoordinate: CLLocationCoordinate2D?
  //当前位置地址
  var curAddress: String?
  //回调(经纬度  地址  错误信息)闭包
  var  callBack:locationCallBack?
  //回调(地理编码:经纬度)闭包
  var callLocationBack:returnLocation?
    
  public func creatLocationManager() -> LocationManager{
    manager = CLLocationManager()
    //设置定位服务管理器代理
    manager?.delegate = self
    //设置定位模式
    manager?.desiredAccuracy = kCLLocationAccuracyBest
    //更新距离
    manager?.distanceFilter = 100
    //发送授权申请
    manager?.requestWhenInUseAuthorization()
    //允许后台定位
//    manager?.allowsBackgroundLocationUpdates = true
    return self
  }
  
  //更新位置
  public func startLocation(resultBack:@escaping locationCallBack){
    self.callBack = resultBack
    if CLLocationManager.locationServicesEnabled(){
      //允许使用定位服务的话，开启定位服务更新
      manager?.startUpdatingLocation()
    }
  }
  
  /**地理编码:把地名转换成经纬度,可能会出现一对多的情况;*/
  public func geocoderClick(address:String, returnLocation:@escaping returnLocation){
   var location = CLLocation()
    //创建地理编码对象
    let geo:CLGeocoder=CLGeocoder()
    //placemarks: 地标对象
    //CLPlacemark中有CLLocation（可以获得经纬度），region，街道名称，城市，州很多信息。
    geo.geocodeAddressString(address) { (placemarks, error) in
      for placemark:CLPlacemark in placemarks!{
        if (placemarks?.count==0)||(error != nil){
          print("解析出错")
        }
        //获取经纬度等信息
//        print(placemark.location?.coordinate.latitude as Any)
        //把获取的经纬读保存到闭包里面
//        self.callLocationBack?(placemark.location) ?? returnLocation(CLLocation())
        //用returnLocation这个闭包去拿self.callLocationBack里面的值
//        self.callLocationBack = returnLocation
//        returnLocation(placemark.location)
        location = placemark.location ?? CLLocation()
      }
      returnLocation(location)
    }
    
  }
  
  /**反地理编码---经纬度变成地址*/
  public func reverceGeocoderClick(latitude:Double,longitude:Double, returnAdress:@escaping returnAdress) {
    var address = String()
    //创建地理编码对象
    let geo:CLGeocoder=CLGeocoder()
    //创建位置
    let l1:CLLocation=CLLocation(latitude: latitude, longitude: longitude)
    geo.reverseGeocodeLocation(l1) { (placemarks, error) in
      //解析数据反地理编码,只会对应一个唯一的地址,所以不需要for循环
      if (placemarks?.count==0)||(error != nil){
        print("解析出错")
      }
      let placemark:CLPlacemark=(placemarks?.last)!

      //行政区域
      if let administrativeArea =  placemark.administrativeArea {
        address = administrativeArea
      }
      //城市
      if let locality = placemark.locality {
        address.append(locality)
      }
      //详细地址
      if let name = placemark.name {
        address.append(name)
      }
      returnAdress(address)
    }
    
  }
  
  //CLLocationCoordinate2D 转 CLLocation
  public func constructWithCLLocation(coordinate:CLLocationCoordinate2D) -> CLLocation{
    return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
  
  //CLLocation 转 CLLocationCoordinate2D
  public func constructWithCLLocationCoordinate2D(loaction:CLLocation) -> CLLocationCoordinate2D{
    return loaction.coordinate
  }

}

extension LocationManager:CLLocationManagerDelegate {
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //获取最新的坐标
    curLocation = locations.last!
    //停止定位
    if locations.count > 0{
      manager.stopUpdatingLocation()
      LonLatToCity()
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    callBack!(nil,nil,"定位失败===\(error)")
  }
  
  //反地理编码---经纬度变成地址
  func LonLatToCity() {
    let geocoder: CLGeocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(self.curLocation!) { (placemark, error) -> Void in
      if(error == nil){
        let firstPlaceMark = placemark!.first
        
        self.curAddress = ""
        //省
        if let administrativeArea = firstPlaceMark?.administrativeArea {
          self.curAddress?.append(administrativeArea)
        }
        //自治区
        if let subAdministrativeArea = firstPlaceMark?.subAdministrativeArea {
          self.curAddress?.append(subAdministrativeArea)
        }
        //市
        if let locality = firstPlaceMark?.locality {
          self.curAddress?.append(locality)
        }
        //区
        if let subLocality = firstPlaceMark?.subLocality {
          self.curAddress?.append(subLocality)
        }
        //地名
        if let name = firstPlaceMark?.name {
          self.curAddress?.append(name)
        }

        self.callBack!(self.curLocation,self.curAddress,nil)
        
      }else{
        self.callBack!(nil,nil,"\(String(describing: error))")
      }
    }
  }
  
}

/*

 print("addressDictionary = \(firstPlaceMark?.addressDictionary)")//AllMessage
 print("name = \(String(describing: firstPlaceMark?.name))")//广珠公路
 print("thoroughfare = \(String(describing: firstPlaceMark?.thoroughfare))")//广珠公路
 print("subThoroughfare = \(String(describing: firstPlaceMark?.subThoroughfare))")//nil
 print("locality = \(String(describing: firstPlaceMark?.locality))")//佛山市
 print("subLocality = \(String(describing: firstPlaceMark?.subLocality))")//顺德区
 print("administrativeArea = \(String(describing: firstPlaceMark?.administrativeArea))")//广东省
 print("subAdministrativeArea = \(String(describing: firstPlaceMark?.subAdministrativeArea))")//nil
 print("postalCode = \(String(describing: firstPlaceMark?.postalCode))")//nil
 print("isoCountryCode = \(String(describing: firstPlaceMark?.isoCountryCode))")//CN
 print("country = \(String(describing: firstPlaceMark?.country))")//中国
 print("inlandWater = \(String(describing: firstPlaceMark?.inlandWater))")//nil
 print("ocean = \(String(describing: firstPlaceMark?.ocean))")//nil
 print("areasOfInterest = \(String(describing: firstPlaceMark?.areasOfInterest))")//nil
 */

