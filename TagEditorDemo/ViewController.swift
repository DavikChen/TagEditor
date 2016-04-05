//
//  ViewController.swift
//  TagEditorDemo
//
//  Created by 崔江涛 on 16/4/5.
//  Copyright © 2016年 KenshinCui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - 生命周期及覆盖方法、属性
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "标签编辑器"
        
        self.view.addSubview(self.tagScrollView)
        self.view.addSubview(self.descriptionLabel)
        
        // 设置默认标签
//        self.tagScrollView.tags = ["风光","花卉"]
    }

    // MARK: - 私有属性
    private lazy var tagScrollView:KCTagScrollView = {
        let temp = KCTagScrollView(frame:CGRect(x: 8.0, y: 16.0, width: self.view.width - 16.0, height: 200.0))
        temp.placeholder = "输入空格或者换行分隔"
        temp.tagChangeHandler = {
            [unowned self] tagScrollView in
            self.descriptionLabel.text = tagScrollView.tags.joinWithSeparator(",")
        }
        return temp
    }()
    
    private lazy var descriptionLabel:UILabel = {
        let temp = UILabel(frame:CGRect(x: 8.0, y: CGRectGetMaxY(self.tagScrollView.frame) + 16.0, width: self.tagScrollView.width, height: 200.0))
        temp.numberOfLines = 0
        temp.textColor = UIColor(hexValue: 0x2385f1)
        temp.fontSize = 15.0
        return temp
    }()


}

