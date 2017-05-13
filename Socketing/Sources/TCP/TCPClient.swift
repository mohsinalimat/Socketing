//
//  TCPClient.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

open class TCPClient: Socketing {
    
    /*
     * connect to server
     * return success or fail with message
     */
    @discardableResult open func connect(timeout: Int) -> Socketing.Result {
        let rs: Int32 = c_c_tcp_socket_connect(self.address, port: Int32(self.port), timeout: Int32(timeout))
        if rs > 0 {
            self.fd = rs
            return .success
        } else {
            switch rs {
            case -1:
                return .failure(Socketing.SocketError.queryFailed)
            case -2:
                return .failure(Socketing.SocketError.connectionClosed)
            case -3:
                return .failure(Socketing.SocketError.connectionTimeout)
            default:
                return .failure(Socketing.SocketError.unknownError)
            }
        }
    }
    
    /*
     * close socket
     * return success or fail with message
     */
    open func close() {
        guard let fd = self.fd else { return }
        
        _ = c_c_tcp_socket_close(fd)
        self.fd = nil
    }
    
    /*
     * send data
     * return success or fail with message
     */
    @discardableResult open func send(data: [Socketing.Byte]) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        let sendsize: Int32 = c_c_tcp_socket_send(fd, buff: data, len: Int32(data.count))
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
    @discardableResult open func send(string: String) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        let sendsize = c_c_tcp_socket_send(fd, buff: string, len: Int32(strlen(string)))
        if sendsize == Int32(strlen(string)) {
            return .success
        } else {
            return .failure(Socketing.SocketError.unknownError)
        }
    }
    
    /*
     *
     * send nsdata
     */
    @discardableResult open func send(data: Data) -> Socketing.Result {
        guard let fd = self.fd else { return .failure(Socketing.SocketError.connectionClosed) }
        
        var buff = Array<Socketing.Byte>(repeating: 0x0,count: data.count)
        (data as NSData).getBytes(&buff, length: data.count)
        let sendsize = c_c_tcp_socket_send(fd, buff: buff, len: Int32(data.count))
        if sendsize == Int32(data.count) {
            return .success
        } else {
            return .failure(Socketing.SocketError.unknownError)
        }
    }
    
    /*
     * read data with expect length
     * return success or fail with message
     */
    open func read(_ expectlen:Int, timeout:Int = -1) -> [Socketing.Byte]? {
        guard let fd: Int32 = self.fd else { return nil }
        
        var buff = Array<Socketing.Byte>(repeating: 0x0,count: expectlen)
        let readLen = c_c_tcp_socket_pull(fd, buff: &buff, len: Int32(expectlen), timeout: Int32(timeout))
        if readLen <= 0 { return nil }
        let rs = buff[0...Int(readLen-1)]
        let data: [Socketing.Byte] = Array(rs)
        
        return data
    }
}
