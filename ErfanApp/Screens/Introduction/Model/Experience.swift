import Foundation

public struct Experience: Codable, Equatable {
    public var id: String?
    public let description: String
    public let fromDate: String
    public let toDate: String?
    public let role: String
    public let skills: [String]
    public let title: String
    
    public init(
        id: String? = nil,
        description: String,
        fromDate: String,
        toDate: String?,
        role: String,
        skills: [String],
        title: String
    ) {
        self.id = id
        self.description = description
        self.fromDate = fromDate
        self.toDate = toDate
        self.role = role
        self.skills = skills
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case fromDate
        case toDate
        case role
        case skills
        case title
    }
    
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        self.fromDate = try container.decode(String.self, forKey: .fromDate)
        self.toDate = try container.decodeIfPresent(String.self, forKey: .toDate) ?? "Present"
        self.role = try container.decode(String.self, forKey: .role)
        self.skills = try container.decode([String].self, forKey: .skills)
        self.title = try container.decode(String.self, forKey: .title)
    }
}


struct ExperienceItem: Identifiable, Equatable, Sendable {
    let id: String
    let title: String
    let role: String
    let description: String
    let fromDate: String
    let toDate: String?
    let skills: [String]
    
    var dateRangeText: String {
        let start = formattedDate(from: fromDate)
        let end = toDate.flatMap { formattedDate(from: $0) } ?? "Present"
        return "\(start) - \(end)"
    }
    
    private func formattedDate(from timestamp: String) -> String {
        guard let interval = TimeInterval(timestamp) else { return timestamp }
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

extension ExperienceItem {
    init(_ experience: Experience) {
        self.id = experience.id ?? UUID().uuidString
        self.title = experience.title
        self.role = experience.role
        self.description = experience.description
        self.fromDate = experience.fromDate
        self.toDate = experience.toDate
        self.skills = experience.skills
    }
}


