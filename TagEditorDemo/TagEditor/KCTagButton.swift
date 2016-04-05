//
//  KCTagButton.swift
//  Tuchong
//
//  Created by Kenshin Cui on 16/1/29.
//  Copyright © 2016年 Bytedance. All rights reserved.
//

import UIKit

public class KCTagButton: KCButton {
    // MARK: - 公共属性

    // MARK: - 生命周期及覆盖方法、属性
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - 私有方法
    private func setup(){
        self.image = UIImage(named: "Framework.bundle/all_tag_close")
        self.selectedImage = UIImage(named: "Framework.bundle/all_tag_close_press")
        self.isContentCenterAlignment = true
        
        self.backgroundColor = UIColor(hexValue: 0xF4F5F6)
        self.titleColor = UIColor(hexValue: 0x808387)
        self.fontSize = 12.0
        self.layer.borderColor = UIColor(hexValue: 0xE2E3E5).CGColor
        self.layer.borderWidth = 1.0/UIScreen.mainScreen().scale
        self.layer.cornerRadius = self.height*0.5
    }

}
