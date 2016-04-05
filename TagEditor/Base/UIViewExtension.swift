//
//  UIViewExtension.swift
//  Tuchong
//
//  Created by KenshinCui on 15/10/8.
//  Copyright © 2015年 Bytedance. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - 属性
    public var size:CGSize {
        get{
            return self.frame.size
        }
        set{
            self.frame.size = newValue
        }
    }
    
    public var origin:CGPoint {
        get{
            return self.frame.origin
        }
        set{
            self.frame.origin = newValue
        }
    }
    
    public var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    
    public var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    
    public var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    
    public var height:CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    //注意：centerX、centerY应该在宽度、高度设置后再设置，否则刷新前错位
    public var centerX:CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    
    public var centerY:CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
    
    public var maxX:CGFloat {
        get{
            return CGRectGetMaxX(self.frame)
        }
        set{
            self.x = newValue - self.width
        }
    }
    
    public var maxY:CGFloat {
        get{
            return CGRectGetMaxY(self.frame)
        }
        set{
            self.y = newValue - self.height
        }
    }
    
    public var captureScreen:UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - 方法
    public func addBorderWithFrame(frame:CGRect,color:UIColor){
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.frame = frame
        self.layer.addSublayer(layer)
    }
    
    public func addTopBorderWithColor(color:UIColor,width:CGFloat){
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.frame = CGRect(x: 0.0, y: 0.0, width: self.width, height: width)
        self.layer.addSublayer(layer)
    }
    
    public func addLeftBorderWithColor(color:UIColor,width:CGFloat){
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: self.height)
        self.layer .addSublayer(layer)
    }
    
    public func addBottomBorderWithColor(color:UIColor,width:CGFloat){
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.frame = CGRect(x: 0.0, y: self.height - width, width: self.width, height: width)
        self.layer.addSublayer(layer)
    }
    
    public func addRightBorderWithColor(color:UIColor,width:CGFloat){
        let layer = CALayer()
        layer.backgroundColor = color.CGColor
        layer.frame = CGRect(x: self.width - width, y: 0.0, width: width, height: self.height)
        self.layer.addSublayer(layer)
    }
    
    /**
    添加阴影
    注意：无法添加每个角的两条边的阴影宽度不同的情况
    
    - parameter inset: 阴影各个边的宽度
    - parameter color: 阴影颜色
    */
    public func addShadowWithInset(inset:UIEdgeInsets,color:UIColor){
        let layer = self.layer
        layer.shadowOpacity = 1.0
        layer.shadowColor = color.CGColor
        layer.shadowRadius = max((inset.bottom+inset.top)*0.5,(inset.right+inset.left)*0.5)
        layer.shadowOffset = CGSize(width:(inset.right-inset.left)*0.5,height:(inset.bottom-inset.top)*0.5)
    }
    
    // MARK: - 非占位隐藏
    private struct DisplayAssociatedKey{
        static var originHeightKey = 0
        static var originWidthKey = 0
    }
    /**
    隐藏元素并且不占用响应位置（下方和上方元素上移或左移）
    注意：仅仅适用于frame布局，不适用与AutoLayout布局,并且成对使用、不支持控件自身动态变化高度（或宽度）的情况
    同时，建议下方或者右方有多个元素动态显示的情况参照一个固定显示的布局而不是参照相邻元素
    
    - parameter   hidden: 是否隐藏
    - parameter forHeight: 高度还是宽度
    */
    public func setDisplayWithHidden(hidden:Bool,forHeight:Bool){
        if hidden {
            if forHeight {
                objc_setAssociatedObject(self, &DisplayAssociatedKey.originHeightKey, self.height, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.height = CGFloat.min
            } else {
                objc_setAssociatedObject(self, &DisplayAssociatedKey.originHeightKey, self.width, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.width = CGFloat.min
            }
        } else {
            if forHeight {
                if let value = objc_getAssociatedObject(self, &DisplayAssociatedKey.originHeightKey) as? CGFloat {
                    self.height = value
                }
            } else {
                if let value = objc_getAssociatedObject(self, &DisplayAssociatedKey.originWidthKey) as? CGFloat {
                    self.width = value                }
            }
        }
        self.hidden = hidden
    }
    
    // 指定方向的圆角设置
    public func setRoundCornerWithCorner(corner:UIRectCorner,radius:CGSize){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
    
    //控件克隆
    public func clone() -> Self?{
        return self.cloneHelper(self)
    }
    private func cloneHelper<T>(type:T) -> T? {
        let archivedViewData = NSKeyedArchiver.archivedDataWithRootObject(self)
        return NSKeyedUnarchiver.unarchiveObjectWithData(archivedViewData) as? T
    }
    
    //设置锚点（旋转、缩放的中心点）
    public func setAnchorPoint(anchorPoint:CGPoint){
        let oldOrigin = self.origin
        self.layer.anchorPoint = anchorPoint
        let newOrigin = self.origin
        
        let transition = CGPoint(x:newOrigin.x - oldOrigin.x,y:newOrigin.y - oldOrigin.y)
        self.center = CGPoint(x: self.centerX - transition.x, y: self.centerY - transition.y)
    }
    public func restoreDefaultAnchorPoint(){
        let oldOrigin = self.origin
        self.layer.anchorPoint = CGPoint(x:0.5,y:0.5)
        let newOrigin = self.origin
        
        let transition = CGPoint(x:newOrigin.x - oldOrigin.x,y:newOrigin.y - oldOrigin.y)
        self.center = CGPoint(x: self.centerX - transition.x, y: self.centerY - transition.y)
    }
    
}