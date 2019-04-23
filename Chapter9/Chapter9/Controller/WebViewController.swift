//
//  WebViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/04/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var targetURL = ""

    @IBOutlet weak private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        loadUrl()
    }

    private func loadUrl() {
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
