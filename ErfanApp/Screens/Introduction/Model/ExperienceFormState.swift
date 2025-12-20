//
//  ExperienceFormState.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/16/25.
//



import Foundation

struct ExperienceFormState: Equatable {
    var title: String
    var role: String
    var description: String
    var fromDate: String
    var toDate: String
    var skillsText: String
    
    init(
        title: String = "",
        role: String = "",
        description: String = "",
        fromDate: String = "",
        toDate: String = "",
        skillsText: String = ""
    ) {
        self.title = title
        self.role = role
        self.description = description
        self.fromDate = fromDate
        self.toDate = toDate
        self.skillsText = skillsText
    }
    
    init(_ item: ExperienceItem) {
        self.title = item.title
        self.role = item.role
        self.description = item.description
        self.fromDate = item.fromDate
        self.toDate = item.toDate ?? ""
        self.skillsText = item.skills.joined(separator: ", ")
    }
    
    func toExperience(id: String?) -> Experience {
        Experience(
            id: id,
            description: description,
            fromDate: fromDate,
            toDate: toDate.isEmpty ? nil : toDate,
            role: role,
            skills: skillsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
            title: title
        )
    }
}

