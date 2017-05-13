//
//  Error.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

public extension Socketing {
    
    public enum SocketError: Error {
        case queryFailed
        case connectionClosed
        case connectionTimeout
        case unknownError
    }
}
