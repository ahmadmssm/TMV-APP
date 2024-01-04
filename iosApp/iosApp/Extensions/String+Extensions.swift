//
//  String+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 21/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import CryptoKit
import CommonCrypto
import Foundation

extension String {
    
    var hash256: String {
        let inputData = Data(utf8)
        if #available(iOS 13.0, *) {
            let hashed = SHA256.hash(data: inputData)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            inputData.withUnsafeBytes { bytes in
                _ = CC_SHA256(bytes.baseAddress, UInt32(inputData.count), &digest)
            }
            return digest.makeIterator().compactMap { String(format: "%02x", $0) }.joined()
        }
    }
    
    func trim() -> String {
        self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
}
