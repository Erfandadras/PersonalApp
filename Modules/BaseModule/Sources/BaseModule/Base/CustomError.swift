//
//  CustomError.swift
//  MaliSamanTask
//
//  Created by Erfan mac mini on 10/10/24.
//

import Foundation

public protocol ErrorProtocol: LocalizedError {
    var title: String? { get }
}

public enum CustomErrorType: Error {
    case isExplicitlyCancelledError
}

public struct CustomError: ErrorProtocol {
    public var title: String?
    public var errorDescription: String? { return _description }
    public var failureReason: String? { return _description }
    private var _description: String

    public init(title: String = "Something wrong happened!",
         description: String) {
        self.title = title
        self._description = description
    }
    
}
