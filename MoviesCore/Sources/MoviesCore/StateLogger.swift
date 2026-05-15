//
//  StateLogger.swift
//

public typealias StateLogger<State> = @Sendable (State) -> Void
