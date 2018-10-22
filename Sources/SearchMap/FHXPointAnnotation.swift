//
//  FHXPointAnnotation.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/22.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

//大头针信息
import UIKit
import MapKit
//默认无界面 能显示图片 
class FHXPointAnnotation: MKPointAnnotation {
  
  var information = String()
  
  func initWithCoorDinate(coordinate:CLLocationCoordinate2D, PointAnnotationTitle title:String, PointAnnotationSubTitle subTitle:String, PointAnnotationInformation information:String){
  
    //标题
    self.title = title;
    //子标题
    self.subtitle = subTitle;
    //坐标
    self.coordinate = coordinate;
    //信息
    self.information = information;
    
  }
  
}
