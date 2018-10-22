//
//  SearchMapView.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/21.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

/*
 MKMapSnapshotter  异步地创建一个静态的地图图像
 MKAnnotation      大头针管理对象
 MKPointAnnotation   
 
 
 
 */

import UIKit

import MapKit
import CoreLocation

public class SearchMapView: UIView {
  //返回选中的地址，经度
  public var messageCallBlock:((_ message:MKMapItem) -> ())?
  //返回当前位置
  public var locationCallBlock:((_ location:CLLocationCoordinate2D) -> ())?
  
  //回到当前位置按键
  let curLocationBtn = UIButton()
  
  let searchView = SearchView()
  //地图管理器
  var locationManager:CLLocationManager!
  //当前Location
  var location = CLLocationCoordinate2D()
  //搜索关键字
  var searchText = String()
  //地址数组
  var addressArr = [MKMapItem]()
  
  let tableView = UITableView()
  //创建地图时指定好位置,不然地图启动时不会放大到当前位置
  var mapView = MKMapView(frame: UIScreen.main.bounds)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    requestLocation()
    addSubview(mapView)
    mapView.addSubview(curLocationBtn)
    addSubview(searchView)
    addSubview(tableView)
    buildUI()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    searchView.frame = CGRect(x: bounds.size.width*0.2*0.5, y: 50, width: bounds.size.width*0.8, height: 30)
    curLocationBtn.frame = CGRect(x: mapView.bounds.size.width-40-20, y: mapView.bounds.size.height-40-20, width: 40, height: 40)
  }
  
  func buildUI(){
    searchView.delegate = self

    curLocationBtn.setImage(Asserts.findImages(named: "maps"), for: .normal)
    curLocationBtn.addTarget(self, action: #selector(curLocationBtnClick), for: .touchUpInside)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.white
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.rowHeight = 40
    tableView.register(SearchMapCell.self, forCellReuseIdentifier: "kSearchMap")
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    mapView.userTrackingMode = .follow
    //地图的显示风格，此处设置使用标准地图
    mapView.mapType = .standard
    //地图是否可滚动，默认为true
    mapView.isScrollEnabled = true
    //地图是否缩放，默认为true
    mapView.isZoomEnabled = true
    //是否显示用户当前位置 ios8之后才有，默认为false
    mapView.showsUserLocation = true
    //为MKMapView设置delegate
    mapView.delegate = self
  }
  
  @objc func curLocationBtnClick(){
    moveMap(coorinate2D: location)
  }
  
}

extension SearchMapView {
  
  //MARK: 请求定位
  func requestLocation(){
    self.locationManager = CLLocationManager()
    if CLLocationManager.locationServicesEnabled(){//判断定位服务是否开启
      if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) || self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization) ){
        if(Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil){
          self.locationManager.requestAlwaysAuthorization()
        }else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil){
          self.locationManager.requestWhenInUseAuthorization()
        }else{
          print("Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
      }
    }else{
      print("定位服务未开启！")
    }
  }
  
  func updateAddress(){
    let mapViewHeight = addressArr.isEmpty ? bounds.size.height : bounds.size.height*0.5
    let tableViewHeight = addressArr.isEmpty ? 0 : bounds.size.height*0.5
    mapView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: mapViewHeight)
    curLocationBtn.frame = CGRect(x: mapView.bounds.size.width-40-20, y: mapView.bounds.size.height-40-20, width: 40, height: 40)
    tableView.frame = CGRect(x: 0, y: mapViewHeight, width: bounds.size.width, height: tableViewHeight)
    tableView.reloadData()
  }
  
  
  //添加大头针
  func addPointAnnotation(coorinate2D:CLLocationCoordinate2D){
    
    //正常是清楚大头针
    mapView.removeOverlays(mapView.overlays)
    mapView.removeAnnotations(mapView.annotations)
    
    //创建MKPointAnnotation对象——代表一个大头针
//    let pointAnnotation = MKPointAnnotation()
    //设置大头针的经纬度
//    pointAnnotation.coordinate = coorinate2D
//    pointAnnotation.title = "Jack"
//    pointAnnotation.subtitle = "hua"
    
    let pointAnnotation = FHXPointAnnotation()
    
    pointAnnotation.initWithCoorDinate(coordinate: coorinate2D, PointAnnotationTitle: "冯汉栩", PointAnnotationSubTitle: "fenghanxu", PointAnnotationInformation: "北窖慧聪家电城")
    //添加大头针
    mapView.addAnnotation(pointAnnotation)
    //移动地图
    moveMap(coorinate2D: coorinate2D)
    
  }
  
  //移动地图
  func moveMap(coorinate2D:CLLocationCoordinate2D){
    //设置地图显示的范围，地图显示范围越小，细节越清楚
    let span = MKCoordinateSpan(latitudeDelta:0.005, longitudeDelta:0.005)
    //创建MKCoordinateRegion对象，该对象代表了地图的显示中心和显示范围。
    let region = MKCoordinateRegion(center: coorinate2D, span: span)
    //设置当前地图的显示中心和显示范围
    self.mapView.setRegion(region, animated:true)
  }
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }
  
}

extension SearchMapView: MKMapViewDelegate {
  
  //当用户位置发生变化时调用,调用非常频繁，不断监测用户的当前位置,每次调用，都会把用户的最新位置（userLocation参数）传进来。
  public func mapView(_ mapView:MKMapView, didUpdate userLocation:MKUserLocation){
    location = userLocation.coordinate
    locationCallBlock!(userLocation.coordinate)
  }
  
  //地图的显示区域即将发生改变的时候调用
  public func mapView(_ mapView:MKMapView, regionWillChangeAnimated animated:Bool) {
//    self.endEditing(true)
  }
  
  //地图的显示区域已经发生改变的时候调用
  public func mapView(_ mapView:MKMapView, regionDidChangeAnimated animated:Bool) {
//    print("当显示的区域发生变化时调用！")
  }
  
  //地图控件即将开始加载地图数据
  public func mapViewWillStartLoadingMap(_ mapView:MKMapView){
//    print("地图控件开始加载地图数据")
  }
  
  //当MKMapView加载数据完成时激发该方法
  public func mapViewDidFinishLoadingMap(_ mapView:MKMapView){
//    print("当MKMapView加载数据完成时激发该方法")
  }
  
  //当MKMapView加载数据失败时激发该方法如：无网络
  private func mapViewDidFailLoadingMap(mapView:MKMapView, withError error:NSError){
//    print("加载地图数据失败:\(error.userInfo)")
  }
  
  //当MKMapView即将开始渲染地图时激发该方法
  public func mapViewWillStartRenderingMap(_ mapView:MKMapView){
//    print("MKMapView即将开始渲染地图时")
  }
  
  //当MKMapView渲染地图完成时激发该方法
  public func mapViewDidFinishRenderingMap(_ mapView:MKMapView, fullyRendered:Bool){
//    print("MKMapView渲染地图完成时")
  }
  
  //配置注释视图
  public func mapView(_ mapView:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView?{
    let identifier = "MKPinAnnotationView"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    if annotation.coordinate.latitude != location.latitude && annotation.coordinate.longitude != location.longitude {

      //从缓存池中取出可以循环利用的大头针view.

      if (annotationView == nil){
        //MKAnnotationView：可以用指定的图片作为大头针的样式，但显示的时候没有动画效果，如果没有给图片的话会什么都不显示,使用MKAnnotationView子类MKPinAnnotationView创建系统样式大头针
        annotationView = FHXPoinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        //显示子标题和标题
//        annotationView!.canShowCallout = true
//        //设置大头针描述的偏移量
//        annotationView!.calloutOffset = CGPoint(x:0, y: -10)
//        //设置大头针描述左边的控件
//        annotationView!.leftCalloutAccessoryView = UIButton(type: .contactAdd)
//        //设置大头针描述右边的控件
//        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      }
      annotationView!.annotation = annotation

    }
    return annotationView
  }
  
  
  //当大头针被添加到地图上时调用（本来用来做区分方向的）
  public func mapView(_ mapView:MKMapView, didAdd views: [MKAnnotationView]){
//    if (views.last?.isKind(of: NSClassFromString("MKModernUserLocationView")!))! {
//      let headingView = FHXUserLocationHeadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//      headingView.center = CGPoint(x: (views.last?.bounds.size.width)!*0.33, y: (views.last?.bounds.size.height)!*0.32)
//      views.last?.addSubview(headingView)
//    }
  }
  
  //当点击左边或者右边附属视图(信息按钮)的时候方法被调用
  public func mapView(_ mapView:MKMapView, annotationView view:MKAnnotationView, calloutAccessoryControlTapped control:UIControl){
//    print("calloutAccessoryControlTapped")
  }
  
  //点击选中大头针
  public func mapView(_ mapView:MKMapView, didSelect view:MKAnnotationView){
//    print("didSelectAnnotationView")
  }
  
  //当大头针被反选，即取消选中的时候调用，可以通过该方法改变选中大头针视图的姿态
  public func mapView(_ mapView:MKMapView, didDeselect view:MKAnnotationView){
//    print("didDeselectAnnotationView")
  }
  
  //当showsUserLocation属性被设置为true，该方法会被调用，即将开始跟踪定位用户位置
  public func mapViewWillStartLocatingUser(_ mapView:MKMapView){
//    print("即将开始跟踪定位用户位置")
    
  }
  
  //当showsUserLocation属性被设置为false，该方法会被调用，停止跟踪用户的位置
  public func mapViewDidStopLocatingUser(_ mapView:MKMapView){
//    print("停止跟踪用户的位置")
    
  }
  
  //无法定位或者用户不允许定位时，即定位失败，触发代理方法
  public func mapView(_ mapView:MKMapView, didFailToLocateUserWithError error:Error){
//    print(error.localizedDescription)
  }
  
  //当拖动大头针的姿态改变的时候触发代理方法
  public func mapView(_ mapView:MKMapView, annotationView view:MKAnnotationView, didChange newState:MKAnnotationViewDragState, fromOldState oldState:MKAnnotationViewDragState){
//    print("didChangeDragStat")
  }
  
  //当用户的跟踪模式改变会触发代理方法
  public func mapView(_ mapView:MKMapView, didChange mode:MKUserTrackingMode, animated:Bool){
//    print("用户的跟踪模式改变")
  }
  
}

extension SearchMapView:SearchViewDelegate {
  
  func searchView(view: SearchView, returnText text: String) {
    searchText = text
    addressArr.removeAll()
    updateAddress()
    print("text = \(text)")
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = text
    let search = MKLocalSearch(request: request)
    search.start {[weak self] ( response, error) in
      guard let base = self else { return }
      if error == nil {
        guard let locationArr = response?.mapItems else {
           return
        }
        base.addPointAnnotation(coorinate2D: (locationArr.first?.placemark.location?.coordinate) ?? base.location)
        base.addressArr = locationArr
        base.updateAddress()
      }else{
        //移动地图
        base.moveMap(coorinate2D: base.location)
      }
    }

  }
  
  func searchView(view: SearchView, clearnText textField: UITextField) {
    addressArr.removeAll()
    updateAddress()
    moveMap(coorinate2D: location)
  }
  
}

extension SearchMapView: UITableViewDelegate,UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addressArr.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchMap", for: indexPath) as! SearchMapCell
    cell.titleLabel.text = addressArr[indexPath.item].name
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    addPointAnnotation(coorinate2D: (addressArr[indexPath.item].placemark.location?.coordinate) ?? location)
    messageCallBlock!(addressArr[indexPath.item])
  }
  
}

