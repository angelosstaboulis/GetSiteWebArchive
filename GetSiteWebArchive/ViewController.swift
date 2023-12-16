//
//  ViewController.swift
//  GetSiteWebArchive
//
//  Created by Angelos Staboulis on 16/12/23.
//

import UIKit
import WebKit
class WebViewKit:NSObject,WKNavigationDelegate{
    var webView = WKWebView()
    var saveURL:String
    var loadURL:String
    init(saveURL: String,loadURL:String) {
        self.saveURL = saveURL
        self.loadURL = loadURL
        super.init()
        self.webView.navigationDelegate =  self
    }
    func loadWebURL(){
        self.webView.load(URLRequest(url: URL(string:loadURL)!))
    }
    func savePDF(){
        DispatchQueue.main.async{
            self.webView.createWebArchiveData { result in
                switch result {
                case .success(let data):
                    FileManager.default.createFile(atPath: self.saveURL, contents: data)
                case .failure(let failure):
                    debugPrint("failure=",failure)
                }
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        savePDF()
    }
}
class ViewController: UIViewController,WKNavigationDelegate{
    var webView = WebViewKit(saveURL: "", loadURL: "")
    @IBOutlet weak var txtExportURL: UITextField!
    @IBOutlet weak var txtExportFolder: UITextField!
    @IBAction func btnCreateFile(_ sender: Any) {
        DispatchQueue.main.async{
            self.webView.saveURL = self.txtExportFolder.text!
            self.webView.loadURL = self.txtExportURL.text!
            self.webView.loadWebURL()
            self.webView.savePDF()
            self.showAlertBox()
            
        }
       
    }
    func showAlertBox(){
        let alertController = UIAlertController()
        alertController.title = "Information Message"
        alertController.message = "File was created!!!"
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
  
   

}

