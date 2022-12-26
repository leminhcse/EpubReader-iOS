//
//  LocalNetworkPrivacy.swift
//  EpubReader
//
//  Created by mac on 15/12/2022.
//

import UIKit

final class LocalNetworkPrivacy: NSObject {
    
    static let shared = LocalNetworkPrivacy()
    
    func triggerLocalNetworkPrivacyAlert() {
        let sock4 = socket(AF_INET, SOCK_DGRAM, 0)
        guard sock4 >= 0 else { return }
        defer { close(sock4) }
        let sock6 = socket(AF_INET6, SOCK_DGRAM, 0)
        guard sock6 >= 0 else { return }
        defer { close(sock6) }
        
        let addresses = addressesOfDiscardServiceOnBroadcastCapableInterfaces()
        var message = [UInt8]("!".utf8)
        for address in addresses {
            address.withUnsafeBytes { buf in
                let sa = buf.baseAddress!.assumingMemoryBound(to: sockaddr.self)
                let saLen = socklen_t(buf.count)
                let sock = sa.pointee.sa_family == AF_INET ? sock4 : sock6
                _ = sendto(sock, &message, message.count, MSG_DONTWAIT, sa, saLen)
            }
        }
    }
    
    private func addressesOfDiscardServiceOnBroadcastCapableInterfaces() -> [Data] {
        var addrList: UnsafeMutablePointer<ifaddrs>? = nil
        let err = getifaddrs(&addrList)
        guard err == 0, let start = addrList else {
            return []
        }
        defer { freeifaddrs(start) }
        return sequence(first: start, next: { $0.pointee.ifa_next })
            .compactMap { i -> Data? in
                guard
                    (i.pointee.ifa_flags & UInt32(bitPattern: IFF_BROADCAST)) != 0,
                    let sa = i.pointee.ifa_addr
                else {
                    return nil
                }
                var result = Data(UnsafeRawBufferPointer(start: sa, count: Int(sa.pointee.sa_len)))
                switch CInt(sa.pointee.sa_family) {
                    case AF_INET:
                        result.withUnsafeMutableBytes { buf in
                            let sin = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in.self)
                            sin.pointee.sin_port = UInt16(9).bigEndian
                        }
                    case AF_INET6:
                        result.withUnsafeMutableBytes { buf in
                            let sin6 = buf.baseAddress!.assumingMemoryBound(to: sockaddr_in6.self)
                            sin6.pointee.sin6_port = UInt16(9).bigEndian
                        }
                    default:
                        return nil
                }
                return result
        }
    }
}
