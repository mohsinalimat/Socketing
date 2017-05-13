//
//  TCPBridge.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

@_silgen_name("c_tcp_socket_connect") public func c_c_tcp_socket_connect(_ host:UnsafePointer<Socketing.Byte>,port:Int32,timeout:Int32) -> Int32
@_silgen_name("c_tcp_socket_close") public func c_c_tcp_socket_close(_ fd:Int32) -> Int32
@_silgen_name("c_tcp_socket_send") public func c_c_tcp_socket_send(_ fd:Int32,buff:UnsafePointer<Socketing.Byte>,len:Int32) -> Int32
@_silgen_name("c_tcp_socket_pull") public func c_c_tcp_socket_pull(_ fd:Int32,buff:UnsafePointer<Socketing.Byte>,len:Int32,timeout:Int32) -> Int32
@_silgen_name("c_tcp_socket_listen") public func c_c_tcp_socket_listen(_ address:UnsafePointer<Int8>,port:Int32)->Int32
@_silgen_name("c_tcp_socket_accept") public func c_c_tcp_socket_accept(_ onsocketfd:Int32,ip:UnsafePointer<Int8>,port:UnsafePointer<Int32>,timeout:Int32) -> Int32
@_silgen_name("c_tcp_socket_port") public func c_c_tcp_socket_port(_ fd:Int32) -> Int32

public struct TCP {
    public typealias Client = TCPClient
    public typealias Server = TCPServer
}
