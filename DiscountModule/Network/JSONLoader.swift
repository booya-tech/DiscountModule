//
//  JSONLoader.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/18/25.
//

import Foundation

class JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("❌ File not found: \(filename)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("❌ Decoding error: \(error)")
            return nil
        }
    }
}
