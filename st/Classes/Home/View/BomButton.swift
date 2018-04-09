//
//  BomButton.swift
//  st
//
//  Created by 林劲民 on 2018/3/22.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

class BomButton: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x:0, y:contentRect.size.width, width: contentRect.size.width, height: contentRect.size.height - contentRect.size.width)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x:0, y:0, width: contentRect.size.width, height: contentRect.size.width)
    }
    
    
}
