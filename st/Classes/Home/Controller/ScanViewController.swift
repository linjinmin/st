//
//  ScanViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/18.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import swiftScan

class ScanViewController: LBXScanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "扫一扫"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        let result = arrayResult[0].strScanned
        print("\(result ?? "")")
        
    }

}
