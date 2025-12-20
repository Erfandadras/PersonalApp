//
//  IntroductionService.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/16/25.
//

import ServiceModule
import Foundation

// MARK: - protocol
protocol IntroductionServiceProtocol {
    func fetchUser(userId: String) async throws -> UserIntroduction
    func upsertUser(userId: String, _ user: UserIntroduction) async throws
    func observeUser(userId: String) -> AsyncThrowingStream<UserIntroduction, Error>
}

// MARK: - Introduction service
final class IntroductionService: NSObject {
    // MARK: - properties
    private let service: FirestoreService
    
    // MARK: - init
    init(service: FirestoreService = FirestoreService()) {
        self.service = service
    }
}

// MARK: - logic
extension IntroductionService: IntroductionServiceProtocol {
    func fetchUser(userId: String) async throws -> UserIntroduction {
        try await service.get(collection: .users,
                              documentId: userId,
                              as: UserIntroduction.self)
    }
    
    func upsertUser(userId: String, _ user: UserIntroduction) async throws {
        try await service.set(
            collection: .users,
            documentId: userId,
            data: user,
            merge: true
        )
    }
    
    func observeUser(userId: String) -> AsyncThrowingStream<UserIntroduction, any Error> {
        service.listen(collection: .users,
                       documentId: userId,
                       as: UserIntroduction.self)
    }
    
}

