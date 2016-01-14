//
//  ViewController.swift
//  YNWebViewController
//
//  Created by Tommy on 15/12/15.
//  Copyright © 2015年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func presentController(sender: AnyObject) {
        let webViewController = YNWebViewController(url: NSURL(string: "https://www.apple.com")!)
        webViewController.delegate = self
        let navController = UINavigationController(rootViewController: webViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

