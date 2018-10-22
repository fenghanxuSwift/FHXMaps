//
//  FHXPinAnnotationView.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/22.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

import UIKit
import MapKit
//默认有界面 不能显示图片
class FHXPoinAnnotationView: MKPinAnnotationView {

//  var myPointAnnotation = FHXPointAnnotation()
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//    myPointAnnotation = annotation as! FHXPointAnnotation
    
//    let image = UIImageView(image: UIImage(named: "map"))
//    image.frame = CGRect(x: -15, y: -5, width: 45, height: 45)
//    addSubview(image)
    canShowCallout = true
    isDraggable = true
    animatesDrop = true

    let leftBtn = UIButton()
    
    leftBtn.setImage(Asserts.findImages(named: "leftIcon"), for: .normal)
    leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
    leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    leftCalloutAccessoryView = leftBtn
    
    let rightBtn = UIButton()
    rightBtn.setImage(Asserts.findImages(named: "rightIcon"), for: .normal)
    rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
    rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    rightCalloutAccessoryView = rightBtn
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func leftBtnClick(){
    print("leftBtnClick")
  }

  @objc func rightBtnClick(){
    print("rightBtnClick")
  }
  
}
