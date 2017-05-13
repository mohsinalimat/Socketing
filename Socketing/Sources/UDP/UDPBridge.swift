//
//  UPDBridge.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

@_silgen_name("c_udp_socket_server") public func c_c_udp_socket_server(_ host:UnsafePointer<Int8>,port:Int32) -> Int32
@_silgen_name("c_udp_socket_recive") public func c_c_udp_socket_recive(_ fd:Int32,buff:UnsafePointer<Socketing.Byte>,len:Int32,ip:UnsafePointer<Int8>,port:UnsafePointer<Int32>) -> Int32
@_silgen_name("c_udp_socket_close") public func c_c_udp_socket_close(_ fd:Int32) -> Int32
@_silgen_name("c_udp_socket_client") public func c_c_udp_socket_client() -> Int32
@_silgen_name("c_udp_socket_get_server_ip") public func c_c_udp_socket_get_server_ip(_ host:UnsafePointer<Int8>,ip:UnsafePointer<Int8>) -> Int32
@_silgen_name("c_udp_socket_sentto") public func c_c_udp_socket_sentto(_ fd:Int32,buff:UnsafePointer<Socketing.Byte>,len:Int32,ip:UnsafePointer<Int8>,port:Int32) -> Int32
@_silgen_name("enable_broadcast") public func c_enable_broadcast(_ fd:Int32)

public struct UDP {
    public typealias Client = UDPClient
    public typealias Server = UDPServer
}
