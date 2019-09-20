//
//  SocketViewController.swift
//  WTKNetDemo
//
//  Created by 王同科 on 2019/9/16.
//  Copyright © 2019 王同科. All rights reserved.
//

import UIKit
import Toast_Swift

class SocketViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, WTKSocketDelegate {

    

    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var chatTXF: UITextField!
    @IBOutlet weak var urlTxf: UITextField!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [String]()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        WTKSocketTool.default.socket?.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    func configView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.keyboardDismissMode = .onDrag
        
        WTKSocketTool.default.delegate = self
    }

    @IBAction func conneectClick(_ sender: UIButton) {
//        WTKSocketTool.default.socket.connect()
        WTKSocketTool.default.connect(urlTxf.text ?? "")
    }
    @IBAction func sendBtnClick(_ sender: UIButton) {
        let msg = chatTXF.text ?? ""
        if msg.isEmpty {
            Toast.show("请输入内容")
            return
        }
        if WTKSocketTool.default.socket?.isConnected ?? false {
            WTKSocketTool.default.send(msg) {
                Toast.show("发送成功")
            }
            chatTXF.text = ""
            chatTXF.resignFirstResponder()
            
        } else {
            Toast.show("未连接socket")
        }
        
    }

}

extension SocketViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
}
extension SocketViewController {
    func webSocketReciveMsg(_ msg: String) {
        debugPrint("收到消息----\(msg)")
        dataArray.append(msg)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath.init(row: dataArray.count - 1, section: 0), at: .bottom, animated: true)
    }
    func websocketDidConnect() {
        debugPrint("connectSuccess......")
    }
    
    func websocketDidDisconnect() {
        Toast.show("连接失败，请检查网络和url")
    }
}
