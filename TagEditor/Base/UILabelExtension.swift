
//
//  UILabelExtension.swift
//  Tuchong
//
//  Created by KenshinCui on 15/10/12.
//  Copyright © 2015年 Bytedance. All rights reserved.
//

import UIKit

//注意：考虑到系统可能统一控制字体适配，因此暂时注释掉，根据app是否自定义fontSize属性的情况打开
extension UILabel{
    
    public var fontSize:CGFloat {
        get{
            return self.font.pointSize
        }
        set{
            self.font = UIFont.systemFontOfSize(newValue)
        }
    }
    
    convenience init(frame:CGRect,textColor:UIColor,fontSize:CGFloat){
        self.init(frame:frame)
        self.textColor = textColor
        self.fontSize = fontSize
    }
}