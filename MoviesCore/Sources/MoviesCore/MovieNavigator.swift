//
//  MovieNavigator.swift
//

import FactoryKit

@MainActor
public protocol MovieNavigator: AnyObject {
    func navigate(to movie: MovieDetails)
}

@MainActor
public final class NoopNavigator: MovieNavigator {
    public init() {}
    public func navigate(to movie: MovieDetails) {}
}

extension Container {
    @MainActor
    public var movieNavigator: Factory<any MovieNavigator> {
        self { NoopNavigator() }
    }
}
