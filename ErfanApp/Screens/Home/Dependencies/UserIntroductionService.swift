//
//  UserIntroductionService.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/25/25.
//

import Foundation
import ServiceModule

protocol UserIntroductionExsistenceChecker {
    func hasData(userId: String) async throws -> Bool
}

extension IntroductionService: UserIntroductionExsistenceChecker {
    func hasData(userId: String) async throws -> Bool {
        try await service.checkExistence(collection: .users,
                               documentId: userId)
    }
}
