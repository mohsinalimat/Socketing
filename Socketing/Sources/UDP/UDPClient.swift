//
//  UDPClient.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

open class UDPClient: Socketing {
    public override init(address: String, port: Int32) {
        let remoteipbuff: [Int8] = [Int8](repeating: 0x0,count: 16)
        let ret = c_c_udp_socket_get_server_ip(address, ip: remoteipbuff)
        guard let ip = String(cString: remoteipbuff, encoding: String.Encoding.utf8), ret == 0 else {
            super.init(address: "", port: 0) //TODO: change to init?
            return
        }
        
        super.init(address: ip, port: port)
      
        let fd: Int32 = c_c_udp_socket_client()
        if fd > 0 {
            self.fd = fd
        }
    }
    
    /*
    * send data
    * return success or fail with message
    */
    open func send(data: [Socketing.Byte]) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        let sendsize: Int32 = c_c_udp_socket_sentto(fd, buff: data, len: Int32(data.count), ip: self.address, port: Int32(self.port))
        if Int(sendsize) == data.count {
            return .success
        } else {
            return .failure(Socketing.SocketError.unknownError)
        }
    }
    
    /*
    * send string
    * return success or fail with message
    */
    open func send(string: String) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        let sendsize = c_c_udp_socket_sentto(fd, buff: string, len: Int32(strlen(string)), ip: address, port: port)
        if sendsize == Int32(strlen(string)) {
            return .success
        } else {
            return .failure(Socketing.SocketError.unknownError)
        }
    }
    
    /*
    * enableBroadcast
    */
    open func enableBroadcast() {
        guard let fd: Int32 = self.fd else { return }
        
        c_enable_broadcast(fd)
    }
    
    /*
    *
    * send nsdata
    */
    open func send(data: Data) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        var buff = [Byte](repeating: 0x0,count: data.count)
        (data as NSData).getBytes(&buff, length: data.count)
        let sendsize = c_c_udp_socket_sentto(fd, buff: buff, len: Int32(data.count), ip: address, port: port)
        if sendsize == Int32(data.count) {
            return .success
        } else {
            return .failure(Socketing.SocketError.unknownError)
        }
    }
    
    //TODO add multycast and boardcast
    open func recv(_ expectlen: Int) -> ([Socketing.Byte]?, String, Int) {
        guard let fd = self.fd else {
            return (nil, "no ip", 0)
        }
        var buff: [Socketing.Byte] = Array<Socketing.Byte>(repeating: 0x0, count: expectlen)
        var remoteipbuff: [Int8] = [Int8](repeating: 0x0, count: 16)
        var remoteport: Int32 = 0
        let readLen: Int32 = c_c_udp_socket_recive(fd, buff: buff, len: Int32(expectlen), ip: &remoteipbuff, port: &remoteport)
        let port: Int = Int(remoteport)
        let address = String(cString: remoteipbuff, encoding: String.Encoding.utf8) ?? ""
        
        if readLen <= 0 {
            return (nil, address, port)
        }

        let data: [Socketing.Byte] = Array(buff[0..<Int(readLen)])
        return (data, address, port)
    }
    
    open func close() {
        guard let fd = self.fd else { return }
        
        _ = c_c_udp_socket_close(fd)
        self.fd = nil
    }
    //TODO add multycast and boardcast
}
