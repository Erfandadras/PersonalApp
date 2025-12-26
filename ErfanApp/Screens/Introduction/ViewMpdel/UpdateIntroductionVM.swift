//
//  UpdateIntroductionVM.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/26/25.
//

import ServiceModule
import BaseModule
import Combine
import Foundation
import UIKit

final class UpdateIntroductionVM: BaseViewModel {
    // services
    private let introductionService: IntroductionServiceProtocol
    
    // MARK: - init
    init(
        introductionService: IntroductionServiceProtocol = IntroductionService()
    ) {
        self.introductionService = introductionService
        super.init()
    }
}

extension UpdateIntroductionVM {
    @MainActor
    private func createIntroduction(model: UserIntroduction) async -> Bool {
        @Injected var userManager: UserManager
        self.updateState(state: .setLoading(value: true))
        guard let userId = userManager.userId else {
            Logger.log(.function, level: .error, "failed to get user id")
            toast = .init(type: .error, message: "Failed to get User Id")
            self.updateState(state: .failure(error: CustomError(description: "Failed to get user Id")))
            return false }
        
        do {
            try await introductionService.upsertUser(userId: userId, model)
            await MainActor.run {
                self.updateState(state: .setLoading(value: false))
                self.updateState(state: .success())
                self.toast = .init(type: .success, message: "Introduction saved successfully")
            }
            return true
        } catch {
            Logger.log(.function,
                       level: .error,
                       error.localizedDescription)
            await MainActor.run {
                self.updateState(state: .setLoading(value: false))
                self.toast = .init(type: .error, message: "Failed to save Introduction")
            }
            return false
        }
    }
    
    
    func saveUserIntroduction(model: UserIntroduction, with avatar: UIImage?) async -> Bool {
        do {
            var avatarPath = model.avatar
            if let avatar {
                if let newPath = try saveImageToDocuments(image: avatar, avatarPath: avatarPath) {
                    avatarPath = newPath
                }
            }
            var newModel = model
            newModel.avatar = avatarPath
            try newModel.validate()
            return await createIntroduction(model: newModel)
        } catch {
            Logger.log(.function, level: .error, error.localizedDescription)
            self.updateState(state: .failure(error: error))
            await MainActor.run {
                self.toast = .init(type: .error, message: "Failed to save changes")
            }
            return false
        }
    }
    
    
    @MainActor
    private func saveImageToDocuments(image: UIImage, avatarPath: String? = nil) throws -> String? {
        guard let data = image.pngData() else { return nil }
        let fileName = "avatar_\(Int(Date().timeIntervalSince1970)).png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let directory = documentsDirectory
            .appending(component: "Introduction")
        
        // Delete old avatar if exists? (Optional but good)
        if let oldPath = avatarPath {
            let oldURL = documentsDirectory.appendingPathComponent(oldPath)
            try? FileManager.default.removeItem(at: oldURL)
        }
        if !FileManager.default.fileExists(atPath: directory.path()) {
            try FileManager.default.createDirectory(at: directory,
                                                    withIntermediateDirectories: true)
        }
        let fileURL = directory
            .appendingPathComponent(fileName)
        try data.write(to: fileURL, options: .atomic)
        return "Introduction/\(fileName)"
    }
}

