//
//  WebViewController.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//

import UIKit
import WebKit


class WebViewController: UIViewController {

    let url: String
    private let wv = WKWebView()
    
    init(url: String) {
        self.url = url        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .never
        setSubViews()
    }
    
    func setSubViews() {
        
        let config = WKWebViewConfiguration.init()
        config.processPool = WKProcessPool()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.allowsInlineMediaPlayback = true
        
        wv.navigationDelegate = self
        wv.isOpaque = true
        self.view.addSubview(wv)
        wv.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        wv.load(URLRequest(url: URL(string: url)!))
    }
}

// MARK: - WKWebView WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = webView.title
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
}
