//
//  ConstantsConverter.swift
//  CurrencyConverter
//

import Foundation
import CryptoKit

struct ConstantsConverter {
    
    static func decrypt(input: Data) -> Data? {
        do {
            let keyData = Data(base64Encoded: "nN3wkxSIm/AB2bwI1H9i4+66nCPpg2D0AD1HAs9KAJk=")
            let retrievedKey = SymmetricKey(data: keyData!)
            
            let box = try AES.GCM.SealedBox(combined: input)
            let opened = try AES.GCM.open(box, using: retrievedKey)
            return opened
        } catch let error {
            print("ConstantsConverter, \(#line), error=\(error)")
            return nil
        }
    }
}
