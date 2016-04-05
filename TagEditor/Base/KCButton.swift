
//
//  KCButton.swift
//  Tuchong
//
//  Created by KenshinCui on 15/10/10.
//  Copyright © 2015年 Bytedance. All rights reserved.
//

import UIKit

/**
按钮布局模式

- LeftToRight: 左右布局
- TopToBottom: 上下布局
*/
public enum KCButtonImageTitleMode:Int {
    case LeftToRight
    case TopToBottom
    case RightToLeft
}

public class KCButton:UIButton {
    // MARK: - 属性
    private lazy var badgeLabel:UILabel = {
        let tempLabel = UILabel()
        tempLabel.text = self.badgeValue
        tempLabel.backgroundColor = self.badgeBackgroundColor
        tempLabel.textColor = self.badgeTextColor
        tempLabel.font = self.badgeFont
        
        return tempLabel
    }()
    
    /// 布局模式
    var mode:KCButtonImageTitleMode = .LeftToRight {
        didSet{
            if self.mode == .LeftToRight {
                self.titleLabel?.textAlignment = .Center
                self.imageView?.contentMode = .Center
            } else if self.mode == .TopToBottom {
                self.titleLabel?.textAlignment = .Left
                self.imageView?.contentMode = .Left
            } else {
                self.titleLabel?.textAlignment = .Left
                self.imageView?.contentMode = .Right
            }
        }
    }
    /// 布局模式对应的原始值，用于IB
    @IBInspectable var modeValue:Int = 0 {
        didSet {
            self.mode = KCButtonImageTitleMode(rawValue:self.modeValue)!
        }
    }
    
    /// 图片文字宽高比例，默认0.5
    @IBInspectable var imageHeightScale:Float = 0.5 {
        didSet{
            self.setNeedsLayout()
        }
    }
    /// 内容是否居中，如果为true则imageHeightScale无效
    var isContentCenterAlignment = false {
        didSet{
            self.mode = .RightToLeft
            self.titleLabel?.textAlignment = .Center
            self.imageView?.contentMode = .Center
        }
    }
    
    /// 标识字符
    @IBInspectable var badgeValue:String?{
        didSet{
            if self.badgeValue == nil || (badgeValue == "0" && self.shouldHideBadgeAtZero) {
                self.badgeLabel.hidden = true
            } else {
                self.badgeLabel.hidden = false
            }
            self.badgeLabel.text = self.badgeValue
            self.updateBadgeFrame()
        }
    }
    
    /// 标识符背景色
    var badgeBackgroundColor:UIColor = UIColor.redColor(){
        didSet{
            self.updateBadgeFrame()
        }
    }
    
    /// badge颜色
    var badgeTextColor:UIColor = UIColor.whiteColor(){
        didSet{
            self.updateBadgeFrame()
        }
    }
    
    /// badge字体
    var badgeFont:UIFont = UIFont.systemFontOfSize(12.0){
        didSet{
            self.updateBadgeFrame()
        }
    }
    /// badge字体大小，用于IB
    @IBInspectable var badgeFontSize:Float = 12.0 {
        didSet{
            self.badgeFont = UIFont.systemFontOfSize(CGFloat(self.badgeFontSize))
        }
    }
    
    /// badge的x轴距离，注意只有在没有设置badgeRightOffset时才生效
    @IBInspectable var badgeOriginX:Float = 0{
        didSet{
            self.updateBadgeFrame()
        }
    }
    
    /// badge的y轴距离
    @IBInspectable var badgeOriginY:Float = 0{
        didSet{
            self.updateBadgeFrame()
        }
    }
    
    /// 距离右侧的位置，如果设置此值则badgeOriginX不起作用
    @IBInspectable var badgeRightOffset:Float?{
        didSet{
            self.updateBadgeFrame()
        }
    }
    
    /// 当标识符为0时是否隐藏，默认隐藏
    var shouldHideBadgeAtZero:Bool = true{
        didSet{
            if !self.shouldHideBadgeAtZero && self.badgeValue != nil {
                self.badgeLabel.text = self.badgeValue
                self.updateBadgeFrame()
            }
        }
    }
    
    // MARK: - 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        self.setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.isContentCenterAlignment {
            let titleWidth = self.titleLabel!.width
            let imageWidth = self.imageView!.width
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageWidth, bottom: 0.0, right: imageWidth)
            self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: titleWidth, bottom: 0.0, right: -titleWidth)
        }
    }
    
    override public func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        if self.isContentCenterAlignment {
            return super.imageRectForContentRect(contentRect)
        }
        let size = contentRect.size
        if self.mode == .TopToBottom {
            return CGRect(x: 0.0, y: self.contentEdgeInsets.left, width: size.width, height: size.height * CGFloat(self.imageHeightScale))
        } else if self.mode == .LeftToRight {
            return CGRect(x:self.contentEdgeInsets.left, y: 0.0, width: size.width * CGFloat(self.imageHeightScale), height: size.height)
        } else {
            let x = size.width * CGFloat(1 - self.imageHeightScale) + self.contentEdgeInsets.left
            let width = size.width * CGFloat(self.imageHeightScale)
            return CGRect(x: x, y: 0.0, width: width, height: size.height)
        }
    }
    
    override public func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        if self.isContentCenterAlignment {
            return super.titleRectForContentRect(contentRect)
        }
        let size = contentRect.size
        if self.mode == .TopToBottom {
            let y = size.height * CGFloat(self.imageHeightScale) + self.contentEdgeInsets.top
            let height = size.height*CGFloat(1 - self.imageHeightScale)
            return CGRect(x: 0.0, y: y, width: size.width, height: height)
        } else if self.mode == .LeftToRight {
            let x = size.width * CGFloat(self.imageHeightScale) + self.contentEdgeInsets.left
            let width = size.width * CGFloat(1 -  self.imageHeightScale)
            return CGRect(x: x, y: 0.0, width: width, height: size.height)
        } else {
            return CGRect(x: self.contentEdgeInsets.left, y: 0.0, width: size.width * CGFloat(1 - self.imageHeightScale), height: size.height)
        }
    }
    
    // MARK: - 公共方法
    
    // MARK: - 私有方法
    private func setup(){
        if self.badgeValue != nil {
            self.addSubview(self.badgeLabel)
            self.updateBadgeFrame()
        }
    }
    
    private func updateBadgeFrame(){
        let size = self.badgeValue!.sizeWithSystemFontSize(self.badgeFont.pointSize)
        let padding = CGFloat(self.badgeValue!.characters.count)
        var width = size.width + 5*padding
        let height = size.height + padding
        
        if height > width {
            width = height
        }
        
        var x:CGFloat = 0.0
        if self.badgeRightOffset != nil {
            x = self.width - CGFloat(self.badgeRightOffset!) - width
        } else {
            x = CGFloat(self.badgeOriginX)
        }
        
        self.badgeLabel.frame = CGRect(x: x, y:CGFloat(self.badgeOriginY), width: width, height: height)
        self.badgeLabel.layer.cornerRadius = height * 0.5
        self.badgeLabel.layer.masksToBounds = true
    }
}