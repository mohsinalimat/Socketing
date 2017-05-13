//
//  ViewController.swift
//  Socketing-Example
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit
import Socketing

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    let host = "127.0.0.1"
    let port: Int32 = 8080
    var client: TCP.Client?
    var server: TCP.Server?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.server = TCP.Server(address: host, port: port)
        self.appendToTextField(string: "[Server] Starting ...")
        if let res = self.server?.listen() {
            switch res {
            case .failure(let error):
                self.appendToTextField(string: "[Server] Listen: \(error)")
            default:
                self.appendToTextField(string: "[Server] Listen: Success")
                DispatchQueue.global().async { [weak self] () in
                    while true {
                        if let c = self?.server?.accept() {
                            self?.echo(client: c)
                        } else {
                            self?.appendToTextField(string: "[Server] Accept: Error!")
                        }
                    }
                }
            }
        }
        self.client = TCP.Client(address: host, port: port)
        self.appendToTextField(string: "[Client] Starting ...")
    }
    
    func echo(client c: TCP.Client) {
        self.appendToTextField(string: "[Server] New Client: \(c.address)[\(c.port)]")
        let d = c.read(length: 1024*10)
        c.send(data: d!)
        c.close()
    }
    
    @IBAction func sendButtonAction() {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            appendToTextField(string: "[Client] Connected to Host: \(client.address)[\(client.port)]")
            let str = "THIS IS A MESSAGE SENDING TO \(client.address)[\(client.port)]"
            if let response = sendRequest(string: str, using: client) {
                appendToTextField(string: "[Client] Sent: \"\(response)\"")
            }
        case .failure(let error):
            appendToTextField(string: "[Client] Sending Error: " + String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: TCP.Client) -> String? {
        appendToTextField(string: "[Client] Sending: \"\(string)\" ...")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(_):
//            appendToTextField(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCP.Client) -> String? {
        guard let response = client.read(length: 1024 * 10) else { return nil }
        return String(bytes: response, encoding: .utf8)
    }
    
    private func appendToTextField(string: String) {
        print(string)
        DispatchQueue.main.async { [weak self] () in
            self?.textView.text = self?.textView.text.appending("\n\(string)")
        }
    }
}

