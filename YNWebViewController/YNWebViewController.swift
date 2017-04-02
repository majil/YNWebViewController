//
//  YNWebViewController.swift
//  YNWebViewController
//
//  Created by Tommy on 15/12/15.
//  Copyright © 2015年 xu_yunan@163.com. All rights reserved.
//

import UIKit

public class YNWebViewController: UIViewController, UIWebViewDelegate {

    public var request: URLRequest
    public var webView = UIWebView()
    public var delegate: UIWebViewDelegate?

    public lazy var backBarButtonItem: UIBarButtonItem = {
        
        // for cocoapods
        let bundle = Bundle(for: YNWebViewController.self)
        let backImage = UIImage(named: "YNWebViewControllerBack.png", in: bundle, compatibleWith: nil)
        
        let item = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(YNWebViewController.goBackTapped(_:)))
        item.width = 18
        return item
    }()
    
    public lazy var forwardBarButtonItem: UIBarButtonItem = {
        
        // for cocoapods
        let bundle = Bundle(for: YNWebViewController.self)
        let nextImage = UIImage(named: "YNWebViewControllerNext.png", in: bundle, compatibleWith: nil)
        
        let item = UIBarButtonItem(image: nextImage, style: .plain, target: self, action: #selector(YNWebViewController.goForwardTapped(_:)))
        item.width = 18
        return item
    }()
    
    public lazy var refreshBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(YNWebViewController.reloadTapped(_:)))
        return item
    }()
    
    public lazy var stopBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(YNWebViewController.stopTapped(_:)))
        return item
    }()
    
    public lazy var actionBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(YNWebViewController.actionButtonTapped(_:)))
        return item
    }()
    
    convenience public init(url: URL) {
        self.init(request: URLRequest(url: url))
    }
    
    public init(request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        webView.frame = UIScreen.main.bounds
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
        view.addSubview(webView)
    }

    public func updateToolbarItems() {
        self.backBarButtonItem.isEnabled = self.webView.canGoBack
        self.forwardBarButtonItem.isEnabled = self.webView.canGoForward
        
        let refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [fixedSpace, self.backBarButtonItem, flexibleSpace, self.forwardBarButtonItem, flexibleSpace, refreshStopBarButtonItem, flexibleSpace, self.actionBarButtonItem, fixedSpace]
        self.toolbarItems = items
        
        self.navigationController!.toolbar.barStyle = self.navigationController!.navigationBar.barStyle
        self.navigationController!.toolbar.tintColor = self.navigationController!.navigationBar.tintColor
    }
    
    public func goBackTapped(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    public func goForwardTapped(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    public func reloadTapped(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    public func stopTapped(_ sender: UIBarButtonItem) {
        self.webView.stopLoading()
        self.updateToolbarItems()
    }
    
    func actionButtonTapped(_ sender: UIBarButtonItem) {
        let requestURL = self.webView.request!.url ?? self.request.url
        if let url = requestURL {
            let activityItems = [YNWebViewControllerActivitySafari(), YNWebViewControllerActivityChrome()]
            if url.absoluteString.hasPrefix("file:///") {
                let dc = UIDocumentInteractionController(url: url)
                dc.presentOptionsMenu(from: self.view.bounds, in: self.view, animated: true)
            } else {
                let activityController = UIActivityViewController(activityItems:[url] , applicationActivities: activityItems)
                self.present(activityController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UIWebViewDelegate
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.updateToolbarItems()
        delegate?.webViewDidStartLoad?(webView)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.updateToolbarItems()
        self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title") ?? "title"
        delegate?.webViewDidFinishLoad?(webView)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.updateToolbarItems()
        delegate?.webView?(webView, didFailLoadWithError: error)
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return (delegate?.webView?(webView, shouldStartLoadWith: request, navigationType: navigationType)) ?? true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.delegate = nil
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
