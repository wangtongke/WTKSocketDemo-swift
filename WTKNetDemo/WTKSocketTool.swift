//
//  WTKSocketTool.swift
//  WTKNetDemo
//
//  Created by 王同科 on 2019/9/17.
//  Copyright © 2019 王同科. All rights reserved.
//

import UIKit
import Starscream
import Toast_Swift

protocol WTKSocketDelegate: NSObjectProtocol {
    func webSocketReciveMsg(_ msg: String)
    
    /// optional
    func websocketDidConnect()
    
    /// optional
    func websocketDidDisconnect()
}

extension WTKSocketDelegate {
    func websocketDidConnect() {}
    func websocketDidDisconnect(){}
}

class WTKSocketTool: NSObject, WebSocketDelegate {
    
    static let `default` = WTKSocketTool()
    
    var socket: WebSocket?
    
    weak var delegate: WTKSocketDelegate?
    
    
    override init() {
        super.init()
        
    }
    
    func connect(_ urlS: String) {
        socket?.disconnect()
        socket?.delegate = nil
        var request = URLRequest.init(url: URL.init(string: urlS)!)
        request.httpBody = Data.init(base64Encoded: "iphone")
//        socket = WebSocket.init(url: URL(string: urlS)!)
        socket = WebSocket.init(request: request)
//        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        
    }
    func send(_ text: String, completion: (() -> ())?) {
        socket?.write(string: text, completion: completion)
    }
}

extension WTKSocketTool {
    func websocketDidConnect(socket: WebSocketClient) {
        debugPrint("websocket连接成功........")
        self.delegate?.websocketDidConnect()
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        debugPrint("websocket失去连接++++++++")
        self.delegate?.websocketDidDisconnect()
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        self.delegate?.webSocketReciveMsg(text)
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        debugPrint("收到data----")
    }
}



struct Toast {
    static func setupToastStyle(){
        /// toast样式
        var style = ToastStyle()
        style.cornerRadius = 5 //20.0
        style.messageFont = UIFont.systemFont(ofSize: 15)
        style.horizontalPadding = 15.0
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = false
        ToastManager.shared.position = .center
    }
    
    /// 显示Toast
    ///
    /// - Parameters:
    ///   - message: 消息
    ///   - view: 要显示的view
    ///   - duration: 持续时间
    static func show(_ message: String, duration: TimeInterval = 2, in view: UIView? = nil) {
        
        func showToast(_ view: UIView) {
            view.makeToast(message, duration: duration,
                           position: ToastPosition.center,
                           title: nil,
                           image: nil,
                           style: ToastManager.shared.style,
                           completion: nil)
        }
        
        if let view = view {
            showToast(view)
        } else if let rootView = UIApplication.shared.keyWindow?.rootViewController?.view  {
            showToast(rootView)
        }
    }
    
}
