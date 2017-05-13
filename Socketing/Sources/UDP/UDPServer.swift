//
//  UDPServer.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

open class UDPServer: Socketing {
    
    public override init(address: String, port: Int32) {
        super.init(address: address, port: port)
        
        let fd = c_c_udp_socket_server(address, port: port)
        if fd > 0 {
            self.fd = fd
        }
    }
    
    //TODO add multycast and boardcast
    open func recv(_ expectlen: Int) -> Socketing.ReceivedInfo {
        if let fd = self.fd {
            var buff: [UDPServer.Byte] = Array<UDPServer.Byte>(repeating: 0x0,count: expectlen)
            var remoteipbuff: [Int8] = [Int8](repeating: 0x0,count: 16)
            var remoteport: Int32 = 0
            let readLen: Int32 = c_c_udp_socket_recive(fd, buff: buff, len: Int32(expectlen), ip: &remoteipbuff, port: &remoteport)
            let port: Int = Int(remoteport)
            var address = ""
            if let ip = String(cString: remoteipbuff, encoding: String.Encoding.utf8) {
                address = ip
            }
            
            if readLen <= 0 {
                return (nil, address, port)
            }
            
            let rs = buff[0...Int(readLen-1)]
            let data: [Socketing.Byte] = Array(rs)
            return (data, address, port)
        }
        
        return (nil, "no ip", 0)
    }
    
    open func close() {
        guard let fd = self.fd else { return }
        
        _ = c_c_udp_socket_close(fd)
        self.fd = nil
    }
}
