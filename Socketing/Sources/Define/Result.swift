//
//  Result.swift
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

public extension Socketing {
    
    public enum Result {
        case success
        case failure(Socketing.SocketError)
        
        public var isSuccess: Bool {
            switch self {
            case .success:
                return true
            case .failure:
                return false
            }
        }
        
        public var isFailure: Bool {
            return !isSuccess
        }
        
        public var error: Socketing.SocketError? {
            switch self {
            case .success:
                return nil
            case .failure(let error):
                return error
            }
        }
    }
}


