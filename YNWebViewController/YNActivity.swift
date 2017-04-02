//
//  YNActivity.swift
//  YNWebViewController
//
//  Created by Tommy on 15/12/15.
//  Copyright © 2015年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class YNActivity: UIActivity {
    
    var URLToOpen: URL?
    var schemePrefix: String?
    
    override var activityType: UIActivityType? {
        return UIActivityType(rawValue: NSStringFromClass(self.classForCoder))
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        for activityItem in activityItems {
            if activityItem is URL {
                self.URLToOpen = activityItem as? URL
            }
        }
    }
}


class YNWebViewControllerActivitySafari: YNActivity {
    
    override var activityTitle : String? {
        return "Open in Safari"
    }
    
    override var activityImage : UIImage? {
        return UIImage(named: "YNWebViewControllerActivitySafari.png")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if activityItem is URL && UIApplication.shared.canOpenURL(activityItem as! URL)  {
                return true
            }
        }
        return false
    }
    
    override func perform() {
        let completed = UIApplication.shared.openURL(self.URLToOpen!)
        self.activityDidFinish(completed)
    }
}


class YNWebViewControllerActivityChrome: YNActivity {
    
    override var activityTitle : String? {
        return "Open in Chrome"
    }
    
    override var activityImage : UIImage? {
        return UIImage(named: "YNWebViewControllerActivityChrome.png")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if activityItem is URL && UIApplication.shared.canOpenURL(URL(string: "googlechrome://")!)  {
                return true
            }
        }
        return false
    }
    
    override func perform() {
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
            let rangeForScheme = absoluteString?.range(of: ":")
            let urlNoScheme = absoluteString?.substring(from: (rangeForScheme?.lowerBound)!)
            let chromeURLString = s + urlNoScheme!
            let chromeURL = URL(string: chromeURLString)
            UIApplication.shared.openURL(chromeURL!)
        }
    }
}

