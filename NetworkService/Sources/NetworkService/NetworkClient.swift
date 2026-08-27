//
//  NetworkClient.swift
//

import Foundation
import FactoryKit

public protocol NetworkClient: Sendable {
    func data(from url: URL) async throws -> Data
}

extension Container {
    public var networkClient: Factory<any NetworkClient> {
        self { URLSessionNetworkClient() }
    }
}

public struct URLSessionNetworkClient: NetworkClient {
    public init() {}
    
    public func data(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            return data
        } catch let error as NetworkError {
            throw error
        } catch let error as URLError {
            throw NetworkError(urlError: error) ?? error
        }
    }
}
