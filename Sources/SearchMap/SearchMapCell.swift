//
//  SearchMapCell.swift
//  IOSCoreLocation
//
//  Created by 冯汉栩 on 2018/10/22.
//  Copyright © 2018年 fenghanxu.compang.cn. All rights reserved.
//

import UIKit

class SearchMapCell: UITableViewCell {
  
  let titleLabel = UILabel()
  private let icon = UIImageView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension SearchMapCell {
  
  private func buildUI() {
    backgroundColor = UIColor.white
    addSubview(titleLabel)
    addSubview(icon)
    buildSubview()
  }
  
  private func buildSubview(){
    titleLabel.font = UIFont.systemFont(ofSize: 14)
    
    icon.image = Asserts.findImages(named: "map") ?? UIImage()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel.frame = CGRect(x: 15, y: 3, width: bounds.size.width*0.7, height: bounds.size.height)
    icon.frame = CGRect(x: bounds.size.width-25-10, y: 10, width: 20, height: 20)
  }

}
