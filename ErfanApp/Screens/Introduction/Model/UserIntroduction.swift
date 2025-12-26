//
//  UserIntroduction.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/16/25.
//
import Foundation
import BaseModule

struct UserIntroduction: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var avatar: String?
    var linkedin: String?
    var instagram: String?
    var github: String?
    var title: String
  
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phone = "phone_number"
        case avatar = "avatar_url"
        case linkedin
        case instagram
        case github
        case title
    }
    
    var githubURL: URL? {
        guard let github else { return nil }
        return URL(string: github)
    }
    
    var instagramURL: URL? {
        guard let instagram else { return nil }
        return URL(string: instagram)
    }
    
    var linkedinURL: URL? {
        guard let linkedin else { return nil }
        return URL(string: linkedin)
    }
    
    
    func validate() throws {
        if firstName.isEmpty {
            throw UserIntroductionError.emptyFirstName
        }
        
        if lastName.isEmpty {
            throw UserIntroductionError.emptyLastName
        }
        
        let validator = Validator.email
        if !validator.validate(value: email) {
            throw UserIntroductionError.email
        }
    }
    
    func getAvatarURL() -> URL? {
        guard let avatar else { return nil }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(avatar)
    }
}


enum UserIntroductionError: Error, LocalizedError {
    case emptyFirstName
    case emptyLastName
    case email
}
