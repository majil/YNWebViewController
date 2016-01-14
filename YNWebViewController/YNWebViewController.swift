//
//  YNWebViewController.swift
//  YNWebViewController
//
//  Created by Tommy on 15/12/15.
//  Copyright © 2015年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class YNWebViewController: UIViewController, UIWebViewDelegate {

    var request: NSURLRequest
    var webView = UIWebView()
    var delegate: UIWebViewDelegate?

    private lazy var backBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "YNWebViewControllerBack.png"), style: .Plain, target: self, action: Selector("goBackTapped:"))
        item.width = 18
        return item
    }()
    
    private lazy var forwardBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "YNWebViewControllerNext.png"), style: .Plain, target: self, action: Selector("goForwardTapped:"))
        item.width = 18
        return item
    }()
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("reloadTapped:"))
        return item
    }()
    
    private lazy var stopBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("stopTapped:"))
        return item
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("actionButtonTapped:"))
        return item
    }()
    
    convenience init(url: NSURL) {
        self.init(request: NSURLRequest(URL: url))
    }
    
    init(request: NSURLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbarHidden = false
        webView.frame = UIScreen.mainScreen().bounds
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
        view.addSubview(webView)
    }

    func updateToolbarItems() {
        self.backBarButtonItem.enabled = self.webView.canGoBack
        self.forwardBarButtonItem.enabled = self.webView.canGoForward
        
        let refreshStopBarButtonItem = self.webView.loading ? self.stopBarButtonItem : self.refreshBarButtonItem;
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let items = [fixedSpace, self.backBarButtonItem, flexibleSpace, self.forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem, flexibleSpace, self.actionBarButtonItem, fixedSpace]
        self.toolbarItems = items
        
        self.navigationController!.toolbar.barStyle = self.navigationController!.navigationBar.barStyle
        self.navigationController!.toolbar.tintColor = self.navigationController!.navigationBar.tintColor
    }
    
    func goBackTapped(sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    func goForwardTapped(sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    func reloadTapped(sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    func stopTapped(sender: UIBarButtonItem) {
        self.webView.stopLoading()
        self.updateToolbarItems()
    }
    
    func actionButtonTapped(sender: UIBarButtonItem) {
        let requestURL = self.webView.request!.URL ?? self.request.URL
        if let url = requestURL {
            let activityItems = [YNWebViewControllerActivitySafari(), YNWebViewControllerActivityChrome()]
            if url.absoluteString.hasPrefix("file:///") {
                let dc = UIDocumentInteractionController(URL: url)
                dc.presentOptionsMenuFromRect(self.view.bounds, inView: self.view, animated: true)
            } else {
                let activityController = UIActivityViewController(activityItems:[url] , applicationActivities: activityItems)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.updateToolbarItems()
        delegate?.webViewDidStartLoad?(webView)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.updateToolbarItems()
        self.navigationItem.title = webView.stringByEvaluatingJavaScriptFromString("document.title") ?? "title"
        delegate?.webViewDidFinishLoad?(webView)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.updateToolbarItems()
        delegate?.webView?(webView, didFailLoadWithError: error)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return (delegate?.webView?(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)) ?? true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.delegate = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
