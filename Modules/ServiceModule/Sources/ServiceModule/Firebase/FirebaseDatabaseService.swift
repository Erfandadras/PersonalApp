//
//  FirebaseDatabaseService.swift
//  ServiceModule
//
//  Created by Erfan mac mini on 12/31/25.
//

import Foundation
import FirebaseDatabase
import Combine

public enum FirebaseRTDB: String {
    case base = "https://erfandadras-b0635-default-rtdb.firebaseio.com"
}

public enum FirebaseRTDBError: Error {
    case valueError
}

public protocol FirebaseDatabaseServiceProtocol {
    func observe<T: Decodable>(database: FirebaseRTDB, path: String) -> AsyncThrowingStream<T, Error>
}

public class FirebaseDatabaseService: FirebaseDatabaseServiceProtocol {
    public init() {}
    
    public func observe<T: Decodable>(database: FirebaseRTDB, path: String) -> AsyncThrowingStream<T, any Error> {
        let databaseRef = Database.database(url: database.rawValue)
            .reference()
        let producer = FirebaseStreamProducer<T>(
            ref: databaseRef,
            path: path,
        )
        return producer.start()
    }
}
