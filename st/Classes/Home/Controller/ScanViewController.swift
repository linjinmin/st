//
//  ScanViewController.swift
//  st
//
//  Created by 林劲民 on 2018/3/18.
//  Copyright © 2018年 林劲民. All rights reserved.
//

import UIKit
import swiftScan
import SwiftyJSON
import SVProgressHUD

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
        
        let params = NSMutableDictionary()
        params["method"] = Api.qrScan
        params["identify"] = result
        
        Networking.share().post(Api.host, parameters: params, progress: nil, success: { (task, response) in
            
            let response = JSON(response as Any)
            
            if response["code"].intValue == 200 {
                self.navigationController?.dismiss(animated: true, completion: nil)
                SVProgressHUD.showSuccess(withStatus: response["msg"].stringValue)
            } else {
                SVProgressHUD.showError(withStatus: response["msg"].stringValue)
            }
            
        }) { (task, error) in
            SVProgressHUD.showError(withStatus: Constant.loadFaildText)
        }
        
    }

}
