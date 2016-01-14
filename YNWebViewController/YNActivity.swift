//
//  YNActivity.swift
//  YNWebViewController
//
//  Created by Tommy on 15/12/15.
//  Copyright © 2015年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class YNActivity: UIActivity {
    
    var URLToOpen: NSURL?
    var schemePrefix: String?
    
    override func activityType() -> String? {
        return NSStringFromClass(self.classForCoder)
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if activityItem.isKindOfClass(NSURL.classForCoder()) {
                self.URLToOpen = activityItem as? NSURL
            }
        }
    }
}


class YNWebViewControllerActivitySafari: YNActivity {
    
    override func activityTitle() -> String? {
        return "Open in Safari"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "YNWebViewControllerActivitySafari.png")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for activityItem in activityItems {
            if activityItem.isKindOfClass(NSURL.classForCoder()) && UIApplication.sharedApplication().canOpenURL(activityItem as! NSURL)  {
                return true
            }
        }
        return false
    }
    
    override func performActivity() {
        let completed = UIApplication.sharedApplication().openURL(self.URLToOpen!)
        self.activityDidFinish(completed)
    }
}


class YNWebViewControllerActivityChrome: YNActivity {
    
    override func activityTitle() -> String? {
        return "Open in Chrome"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "YNWebViewControllerActivityChrome.png")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for activityItem in activityItems {
            if activityItem.isKindOfClass(NSURL.classForCoder()) && UIApplication.sharedApplication().canOpenURL(NSURL(string: "googlechrome://")!)  {
                return true
            }
        }
        return false
    }
    
    override func performActivity() {
        let inputURL = self.URLToOpen
        let scheme = inputURL?.scheme
        
        // Replace the URL Scheme with the Chrome equivalent.
        var chromeScheme: String?
        if scheme == "http" {
            chromeScheme = "googlechrome"
        } else if scheme == "https" {
            chromeScheme = "googlechromes"
        }
   
        if let s = chromeScheme {
            let absoluteString = inputURL?.absoluteString
            let rangeForScheme = absoluteString?.rangeOfString(":")
            let urlNoScheme = absoluteString?.substringFromIndex((rangeForScheme?.startIndex)!)
            let chromeURLString = s.stringByAppendingString(urlNoScheme!)
            let chromeURL = NSURL(string: chromeURLString)
            UIApplication.sharedApplication().openURL(chromeURL!)
        }
    }
}

