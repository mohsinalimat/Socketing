//
//  Socketing.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

public typealias Socket = Socketing

open class Socketing {
    
    public let address: String
    internal(set) public var port: Int32
    internal(set) public var fd: Int32?
    
    public init(address: String, port: Int32) {
        self.address = address
        self.port = port
    }
}
