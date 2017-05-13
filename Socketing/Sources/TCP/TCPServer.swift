//
//  TCPServer.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

open class TCPServer: Socketing {
    
    @discardableResult open func listen() -> Socketing.Result {
        let fd = c_c_tcp_socket_listen(self.address, port: Int32(self.port))
        if fd > 0 {
            self.fd = fd
            
            // If port 0 is used, get the actual port number which the server is listening to
            if (self.port == 0) {
                let p = c_c_tcp_socket_port(fd)
                if (p == -1) {
                    return .failure(Socketing.SocketError.unknownError)
                } else {
                    self.port = p
                }
            }
            
            return .success
        }
        return .failure(Socketing.SocketError.unknownError)
    }
    
    open func accept(timeout :Int32 = 0) -> TCPClient? {
        guard let serferfd = self.fd else { return nil }
        
        var buff: [Int8] = [Int8](repeating: 0x0,count: 16)
        var port: Int32 = 0
        let clientfd: Int32 = c_c_tcp_socket_accept(serferfd, ip: &buff, port: &port, timeout: timeout)
        
        guard clientfd >= 0 else { return nil }
        guard let address = String(cString: buff, encoding: String.Encoding.utf8) else { return nil }
        
        let client = TCPClient(address: address, port: port)
        client.fd = clientfd
        
        return client
    }
    
    open func close() {
        guard let fd: Int32=self.fd else { return }
        
        _ = c_c_tcp_socket_close(fd)
        self.fd = nil
    }
}
