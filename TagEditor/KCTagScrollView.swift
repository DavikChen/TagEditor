//
//  KCTagScrollView.swift
//  Tuchong
//
//  Created by Kenshin Cui on 16/1/29.
//  Copyright © 2016年 Bytedance. All rights reserved.
//

import UIKit

/// 标签编辑控件
private let KCTagScrollViewMinAddTextFieldWidth:CGFloat =  20.0
public class KCTagScrollView: UIScrollView,UITextFieldDelegate {
    // MARK: - 公共属性
    public var tags = [String](){
        didSet{
            if !self.isChange {
                self.showTags()
            }
            if self.tags.count == 0 {
                self.addTextField.placeholder = self.placeholder
            } else  if self.tags.count > 0 {
                self.addTextField.placeholder = ""
            }
            
            guard let handler = self.tagChangeHandler else { return }
            handler(tagScrollView: self,tags: self.tags)
        }
    }
    
    public var placeholder:String = "" {
        didSet{
            if self.tags.count == 0 {
                self.addTextField.placeholder = self.placeholder
            } else  if self.tags.count > 0 {
                self.addTextField.placeholder = ""
            }
        }
    }
    
    public var tagLineSpacing:CGFloat = 8.0
    
    public var tagItemSpacing:CGFloat = 15.0
    
    public var tagChangeHandler:((tagScrollView:KCTagScrollView,tags:[String])->Void)?
    
    // MARK: - 生命周期及覆盖方法、属性
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public var contentInset:UIEdgeInsets {
        didSet{
            self.addTextField.width = self.effectiveWidth
        }
    }
    
    public func createTagButtonWithTitle(title:String) -> KCTagButton {
        let temp = KCTagButton()
        temp.title = title
        temp.sizeToFit()
        temp.height = 24.0
        temp.layer.cornerRadius = 12.0
        temp.width += 24.0  // 24.0左右间距各12.0
        if temp.width > self.effectiveWidth {
            temp.width = self.effectiveWidth
        }
        temp.addTarget(self, action: #selector(tagButtonClick(_:)))
        return temp
    }
    
    // MARK: - 事件响应
    func tagButtonClick(sender:KCTagButton){
        self.isChange = true
        var index = 0
        for subview in self.subviews {
            if subview is KCTagButton {
                if subview.isEqual(sender) {
                    break
                }
                index += 1
            }
        }
        self.tags.removeAtIndex(index)
        var lastPoint = sender.origin
        sender.removeFromSuperview()
        for i in index..<self.tags.count {
            if let tagButton = self.getTagButtonWithIndex(i) {
                if lastPoint.x + tagButton.width <= self.effectiveWidth {
                    tagButton.origin = lastPoint
                } else {
                    tagButton.origin = CGPoint(x: 0.0, y: lastPoint.y + tagButton.height + self.tagLineSpacing) 
                }
                lastPoint = CGPoint(x: CGRectGetMaxX(tagButton.frame) + self.tagItemSpacing, y: tagButton.y)
            }
        }
        self.layoutAddTextFieldWithTagButton(self.getTagButtonWithIndex(self.tags.count - 1))
        self.isChange = false
    }
    
    // MARK: - UITextField代理方法
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.lastTextLength = textField.text!.length
        // 增加空格分隔来添加标签功能
        if string == " "{
            if textField.text?.length > 0 {
                self.lastTextLength = 0
                self.addTag()
            }
            return false
        }
        return true
    }
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text?.length > 0 {
            self.lastTextLength = 0
            self.addTag()
        }
        return true
    }
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text?.length > 0 {
            self.lastTextLength = 0
            self.addTag()
        }
        return true
    }
    
    // MARK: - 私有方法
    private func setup(){
        self.backgroundColor = UIColor.whiteColor()
        self.showTags()
    }
    
    private func showTags(){
        self.subviews.forEach{
            if $0 is KCTagButton {
                $0.removeFromSuperview()
            }
        }
        
        var lastPoint = CGPointZero //包括间距
        for tag in self.tags {
            let tagButton = self.createTagButtonWithTitle(tag)
            if lastPoint.x + tagButton.width <= self.effectiveWidth {
                tagButton.origin = lastPoint
            } else {
                tagButton.origin = CGPoint(x: 0.0, y: lastPoint.y + tagButton.height + self.tagLineSpacing)
            }
            lastPoint = CGPoint(x: CGRectGetMaxX(tagButton.frame) + self.tagItemSpacing, y: tagButton.y)
            self.addSubview(tagButton)
        }
        
        self.layoutAddTextFieldWithTagButton(self.subviews.last as? KCTagButton)
        self.addSubview(self.addTextField)
    }
    
    private func addTag(){
        if let txt = self.addTextField.text {
            let tagButton = self.createTagButtonWithTitle(txt)
            
            if self.addTextField.x + tagButton.width <= self.effectiveWidth{
                tagButton.origin = self.addTextField.origin
                
            } else {
                tagButton.origin = CGPoint(x: 0.0, y: CGRectGetMaxY(self.addTextField.frame)+self.tagLineSpacing)
            }
            self.addSubview(tagButton)
            self.layoutAddTextFieldWithTagButton(tagButton)
            
            self.isChange = true
            self.tags.append(txt)
            self.isChange = false

        }
    }
    
    private func layoutAddTextFieldWithTagButton(tagButton:KCTagButton!){
        if tagButton == nil {
            self.addTextField.text = ""
            self.addTextField.becomeFirstResponder()
            self.addTextField.width = self.effectiveWidth
            self.addTextField.origin = CGPointZero
        } else {
            self.addTextField.text = ""
            self.addTextField.becomeFirstResponder()
            if self.effectiveWidth - CGRectGetMaxX(tagButton.frame) - self.tagItemSpacing > KCTagScrollViewMinAddTextFieldWidth {
                self.addTextField.width = self.effectiveWidth - CGRectGetMaxX(tagButton.frame) - self.tagItemSpacing
                self.addTextField.origin = CGPoint(x: CGRectGetMaxX(tagButton.frame) + self.tagItemSpacing, y: tagButton.y)
            } else {
                self.addTextField.width = self.effectiveWidth
                self.addTextField.origin = CGPoint(x: 0.0, y: CGRectGetMaxY(tagButton.frame) + self.tagLineSpacing)
            }
            self.contentSize = CGSize(width: self.effectiveWidth, height: CGRectGetMaxY(self.addTextField.frame))
            //滚动到可视区域
            if CGRectGetMaxY(self.addTextField.frame) > self.contentOffset.y + self.effectiveHeight + self.contentInset.top {
                self.scrollRectToVisible(self.addTextField.frame, animated: true)
            }
        }
    }
    
    private func getTagButtonWithIndex(index:Int) -> KCTagButton? {
        var i = 0
        for subview in self.subviews {
            if subview is KCTagButton {
                if index == i {
                    return subview as? KCTagButton
                }
                i += 1
            }
        }
        return nil
    }
    
    // MARK: - 私有属性
    lazy var addTextField:KCDeleteTextField = {
        let temp = KCDeleteTextField()
        temp.size = CGSize(width: self.effectiveWidth, height: 24.0)
        temp.textColor = UIColor(hexValue: 0x808387)
        temp.font = UIFont.systemFontOfSize(14.0)
        temp.delegate = self
        temp.deleteHandler = {
            [weak self]sender in
            guard let weakSelf = self else { return }
            
            if weakSelf.lastTextLength == 0 && sender.text!.length == 0 {
                if let tagButton = weakSelf.getTagButtonWithIndex(weakSelf.tags.count-1) {
                    weakSelf.tagButtonClick(tagButton)
                }
            }
            if weakSelf.lastTextLength == 1 {
                weakSelf.lastTextLength = 0
            }
        }
        return temp
    }()
    
    private var effectiveWidth:CGFloat {
        return self.width - self.contentInset.left - self.contentInset.right
    }
    private var effectiveHeight:CGFloat {
        return self.height - self.contentInset.top - self.contentInset.bottom
    }
    
    private var isChange = false
    private var lastTextLength = 0

}
