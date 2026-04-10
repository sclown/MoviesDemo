//
//  NetworkError.swift
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case noConnection
    case connectionLost
    case timeout
    case httpError(Int)

    public var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection. Please check your network settings."
        case .connectionLost:
            return "The connection was lost. Please try again."
        case .timeout:
            return "The request timed out. Please try again."
        case .httpError(let code):
            return "Server returned an error (HTTP \(code))."
        }
    }

    init?(urlError: URLError) {
        switch urlError.code {
        case .notConnectedToInternet, .dataNotAllowed:
            self = .noConnection
        case .networkConnectionLost:
            self = .connectionLost
        case .timedOut:
            self = .timeout
        default:
            return nil
        }
    }
}
