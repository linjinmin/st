//
//  UIImage+Original.swift
//  st
//
//  Created by 林劲民 on 2018/2/26.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func createOriginalImage(_ url: String) -> UIImage{
        let image = UIImage(named: url)?.withRenderingMode(.alwaysOriginal)
        return image!
    }
    
}
