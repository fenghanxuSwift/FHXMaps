//
//  FHXUserLocationHeadingView.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/22.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

/*
 在圆点上显示当前方向的三角尖
 由于苹果苹果没有提供想高德，百度地图的API，所以只能自己自定义View来实现，实时获取位置
 */

import UIKit
import CoreLocation

class FHXUserLocationHeadingView: UIView {
  
  let arrowImageView = UIImageView()
  
  let locationManager = CLLocationManager()

  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension FHXUserLocationHeadingView {
  
  private func buildUI() {
    backgroundColor = UIColor.clear
    addSubview(arrowImageView)
    buildSubview()
  }
  
  private func buildSubview(){
    arrowImageView.image = Asserts.findImages(named: "arrow") ?? UIImage()
    locationManager.delegate = self
    
    startUpdatingHeading()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    arrowImageView.frame = frame
  }
  
  func startUpdatingHeading(){
    locationManager.startUpdatingHeading()
  }
  
  func stopUpdatingHeading(){
    locationManager.stopUpdatingHeading()
  }
  
}

extension FHXUserLocationHeadingView:CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    print("course = \(locations.last?.course)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    if newHeading.headingAccuracy < 0 { return }
    let heading =  newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading;
    
//    print("binade = \(heading.binade)")
//    print("significand = \(heading.significand)")
//    print("exponent = \(heading.exponent)")
    print("exponent = \(heading.magnitude)")
    
    //创建旋转动画
    let anim = CABasicAnimation(keyPath: "transform.rotation")
    //旋转角度
    anim.toValue = 1 * M_PI
    //旋转指定角度需要的时间
    anim.duration = 1
    //旋转重复次数
    anim.repeatCount = MAXFLOAT
    //动画执行完后不移除
    anim.isRemovedOnCompletion = true
    //将动画添加到视图的laye上
    arrowImageView.layer.add(anim, forKey: nil)
    //取消动画
    arrowImageView.layer.removeAllAnimations()

    
    let rotation:CGFloat = CGFloat(heading.magnitude/180 * .pi)
    arrowImageView.transform = CGAffineTransform(rotationAngle: rotation);
    

  }
  
}




