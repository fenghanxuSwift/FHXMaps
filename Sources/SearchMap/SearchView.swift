//
//  SearchView.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/21.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

import UIKit

protocol SearchViewDelegate:NSObjectProtocol {
  func searchView(view:SearchView, returnText text:String)
  func searchView(view:SearchView, clearnText textField: UITextField)
}

class SearchView: UIView {
  
  weak var delegate:SearchViewDelegate?
  
  private let searchIcon = UIImageView()
  private let textFiled = UITextField()
  private var searchText = String()

  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension SearchView {
  
  private func buildUI() {
    backgroundColor = UIColor.white
    layer.borderWidth = 1
    layer.borderColor = UIColor.gray.cgColor
    layer.cornerRadius = 15
    layer.masksToBounds = true
    addSubview(searchIcon)
    addSubview(textFiled)
    buildSubview()
    buildLayout()
  }
  
  private func buildSubview(){
    
    searchIcon.image = Asserts.findImages(named: "search") ?? UIImage()
    
    textFiled.placeholder = "请输入地址"
    textFiled.font = UIFont.systemFont(ofSize: 14)
    textFiled.delegate = self
    textFiled.backgroundColor = UIColor.white
    textFiled.clearButtonMode = .whileEditing
  }
  
  private func buildLayout(){
    searchIcon.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
    textFiled.frame = CGRect(x: 35, y: 0, width: 280, height: 30)
  }

  
}

extension SearchView: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
    if !string.isEmpty {
      searchText.append(string)
    }else{
      if searchText.count > 0 {
        let index = searchText.index(searchText.startIndex, offsetBy:searchText.count-1)
        searchText = searchText.substring(to: index)
      }else{
        searchText = String()
      }
    }
    delegate?.searchView(view: self, returnText: searchText)
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    delegate?.searchView(view: self, clearnText: textFiled)
    return true
  }
  
}
