//
//  KCDeleteTextField.swift
//  Tuchong
//
//  Created by Kenshin Cui on 16/1/29.
//  Copyright © 2016年 Bytedance. All rights reserved.
//

import UIKit

public class KCDeleteTextField: UITextField {

    public var deleteHandler:((sender:KCDeleteTextField)->Void)?
    
    override public func deleteBackward() {
        super.deleteBackward()
        guard let handler = self.deleteHandler else { return }
        handler(sender: self)
    }

}
