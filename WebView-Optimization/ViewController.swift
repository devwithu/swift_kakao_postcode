//
//  ViewController.swift
//  WebView-Optimization
//
//  Created by Kent Winder on 06/01/2018.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKScriptMessageHandler {

    
    var webView: WKWebView!
    var popupWebView: WKWebView?
    var urlPath: String = "https://api.doctorwangjin.co.kr/etc/daum_address.php"
    var userContentController = WKUserContentController.init()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebView()
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        
        configuration.userContentController = self.userContentController
        configuration.userContentController.add(self, name: "scriptHandler")

        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
    
    func loadWebView() {
        if let url = URL(string: urlPath) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "scriptHandler"){
            print(message.body)
            // 원하는 함수 실행
            //abc()
        }
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
    
    // alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert);
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in completionHandler() }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async { self.present(alertController, animated: true, completion: nil) }
        
    }
}

extension ViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

