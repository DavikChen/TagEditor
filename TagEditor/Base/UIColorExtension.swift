

//
//  UIColorExtension.swift
//  Tuchong
//
//  Created by KenshinCui on 15/10/10.
//  Copyright © 2015年 Bytedance. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexValue:Int,alpha:Float){
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16)/255.0, green: CGFloat((hexValue & 0xFF00) >> 8)/255.0, blue: CGFloat(hexValue & 0xFF)/255.0, alpha: CGFloat(alpha))
    }
    
    convenience init(hexValue:Int){
        self.init(hexValue:hexValue,alpha:1.0)
    }
    
    convenience init(hexString:String,alpha:Float){
        var newHexString = hexString
        newHexString = newHexString.replace("#", withString: "0x")
        let hexValue = Int(strtoul(newHexString, nil, 0))
        self.init(hexValue:hexValue,alpha:alpha)
    }
    
    convenience init(hexString:String){
        self.init(hexString:hexString,alpha:1.0)
    }
}

extension String{
    public var length:Int{
        return self.characters.count
    }
    
    public func replace(target:String,withString:String) -> String{
        return self.stringByReplacingOccurrencesOfString(target, withString: withString)
    }
    
    public func sizeWithSystemFont(font:UIFont) -> CGSize {
        return (self as NSString).sizeWithAttributes([NSFontAttributeName:font])
    }
    
    public func sizeWithSystemFontSize(fontSize:CGFloat) -> CGSize {
        return self.sizeWithSystemFont(UIFont.systemFontOfSize(fontSize))
    }
}