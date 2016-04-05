//
//  UIButtonExtension.swift
//  Tuchong
//
//  Created by KenshinCui on 15/10/12.
//  Copyright © 2015年 Bytedance. All rights reserved.
//

import UIKit

extension UIButton{
    // MARK: - 属性
    public var title:String?{
        get {
            return self.titleForState(.Normal)
        }
        set {
            self.setTitle(newValue, forState: .Normal)
        }
    }
    
    public var highlightedTitle:String?{
        get{
            return self.titleForState(.Highlighted)
        }
        set{
            self.setTitle(newValue, forState: .Highlighted)
        }
    }
    
    public var selectedTitle:String?{
        get{
            return self.titleForState(.Selected)
        }
        set{
            self.setTitle(newValue, forState: .Selected)
        }
    }
    
    public var selectedHighlightedTitle:String?{
        get{
            return self.titleForState([.Selected , .Highlighted])
        }
        set{
            self.setTitle(newValue, forState: [.Selected , .Highlighted])
        }
    }
    
    public var titleColor:UIColor? {
        get{
            return self.titleColorForState(.Normal)
        }
        set{
            self.setTitleColor(newValue, forState: .Normal)
        }
    }
    
    public var highlightedColor:UIColor?{
        get{
            return self.titleColorForState(.Highlighted)
        }
        set{
            self.setTitleColor(newValue, forState: .Highlighted)
        }
    }
    
    public var selectedColor:UIColor?{
        get{
            return self.titleColorForState(.Selected)
        }
        set{
            self.setTitleColor(newValue, forState: .Selected)
        }
    }
    
    public var selectedHighlightedColor:UIColor?{
        get{
            return self.titleColorForState([.Selected , .Highlighted])
        }
        set{
            self.setTitleColor(newValue, forState: [.Selected , .Highlighted])
        }
    }
    
    public var disabledColor:UIColor?{
        get{
            return self.titleColorForState(.Disabled)
        }
        set{
            self.setTitleColor(newValue, forState: .Disabled)
        }
    }
    
    
    public var image:UIImage?{
        get{
            return self.imageForState(.Normal)
        }
        set{
            self.setImage(newValue, forState: .Normal)
        }
    }
    
    public var highlightedImage:UIImage?{
        get{
            return self.imageForState(.Highlighted)
        }
        set{
            self.setImage(newValue, forState: .Highlighted)
        }
    }
    
    public var selectedImage:UIImage?{
        get{
            return self.imageForState(.Selected)
        }
        set{
            self.setImage(newValue, forState: .Selected)
        }
    }
    
    public var selectedHighlightedImage:UIImage?{
        get{
            return self.imageForState([.Selected , .Highlighted])
        }
        set{
            self.setImage(newValue, forState: [.Selected , .Highlighted])
        }
    }
    
    public var backgroundImage:UIImage?{
        get{
            return self.backgroundImageForState(.Normal)
        }
        set{
            self.setBackgroundImage(newValue, forState: .Normal)
        }
    }
    
    public var highlightedBackgroundImage:UIImage?{
        get{
            return self.backgroundImageForState(.Highlighted)
        }
        set{
            self.setBackgroundImage(newValue, forState: .Highlighted)
        }
    }
    
    public var selectedBackgroundImage:UIImage?{
        get{
            return self.backgroundImageForState(.Selected)
        }
        set{
            self.setBackgroundImage(newValue, forState: .Selected)
        }
    }
    
    public var fontSize:CGFloat? {
        get{
            return self.titleLabel?.fontSize
        }
        set{
            self.titleLabel?.fontSize = newValue!
        }
    }
    
    // MARK: - 方法
    convenience init(title:String?,normalImage:UIImage? = nil,highlightedImage:UIImage? = nil){
        self.init(type:.Custom)
        self.title = title
        self.image = normalImage
        self.highlightedImage = highlightedImage
    }
    convenience init(title:String?,normalImageName:String? ,highlightedImageName:String? = nil){
        var normalImage:UIImage? = nil
        var highlightedImage:UIImage? = nil
        if let nn = normalImageName {
            normalImage = UIImage(named: nn)
        }
        if let hl = highlightedImageName {
            highlightedImage = UIImage(named: hl)
        }
        self.init(title:title,normalImage:normalImage,highlightedImage:highlightedImage)
    }
    convenience init(normalImage:UIImage,highlightedImage:UIImage? = nil){
        self.init(title:nil,normalImage:normalImage)
    }
    convenience init(normalImageName:String,highlightedImageName:String? = nil){
        self.init(title:nil,normalImageName:normalImageName)
    }
    
    convenience init(title:String?,normalBackgroundImage:UIImage?,highlightedBackgroundImage:UIImage?){
        self.init(type: .Custom)
        self.title = title
        self.backgroundImage = normalBackgroundImage
        self.highlightedBackgroundImage = highlightedBackgroundImage
    }
    convenience init(title:String?,normalBackgroundImageName:String?,highlightedBackgroundImageName:String?){
        var normalBackgroundImage:UIImage? = nil
        var highlightedBackgroundImage:UIImage? = nil
        if let nm = normalBackgroundImageName {
            normalBackgroundImage = UIImage(named: nm)
        }
        if let hl = highlightedBackgroundImageName {
            highlightedBackgroundImage = UIImage(named: hl)
        }
        self.init(title:title,normalBackgroundImage:normalBackgroundImage,highlightedBackgroundImage:highlightedBackgroundImage)
    }

    public func addTarget(target:AnyObject,action:Selector){
        self.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}