//
//  SingleKeyBoard.swift
//  st
//
//  Created by 林劲民 on 2018/3/19.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit

@objc protocol SingleKeyBoardDelegate {
    @objc optional func keyBoardDidClickDoneButton(tool: SingleKeyBoard)
}

class SingleKeyBoard: UIToolbar {
    
    weak var singleDelegate: SingleKeyBoardDelegate?

    static func keyBoardTool() -> SingleKeyBoard {
        return Bundle.main.loadNibNamed("SingleKeyBoard", owner: nil, options: nil)!.last as! SingleKeyBoard
    }
    
    @IBAction func didDown(_ sender: UIBarButtonItem) {
        singleDelegate?.keyBoardDidClickDoneButton!(tool: self)
    }
}
