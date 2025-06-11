//
//  APIModelCodable.swift
//  Search0
//
//  Created by shbaek on 6/11/25.
//
import Foundation

typealias APIModelCodable = APIModel & Codable
public protocol APIModel { }
public extension APIModel where Self: Codable {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else { return nil }
        return from(data: data)
    }
    
    static func from(data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(Self.self, from: data)
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
