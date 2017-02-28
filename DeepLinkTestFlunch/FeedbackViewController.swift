//
//  FeedbackViewController.swift
//  DeepLinkTestFlunch
//
//  Created by Guillaume Boufflers on 22/02/2017.
//  Copyright © 2017 Guillaume Boufflers. All rights reserved.
//

import Foundation
import UIKit

class FeedbackViewController : UIViewController {
    
    var storeId: String = "0";
    var params: AnyObject? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let fDialog = CRFeedbackDialog()
        fDialog.present(from: self, withStoreIdString: storeId, withParams: params as! [AnyHashable : Any]!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}	
