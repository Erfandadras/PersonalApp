import Foundation
import FirebaseFirestore
import ServiceModule

// MARK: - protocol
protocol ExperienceServicing {
    func fetchAll() async throws -> [Experience]
    func upsert(_ experience: Experience) async throws -> String
    func delete(id: String) async throws
    func observeAll() -> AsyncThrowingStream<[Experience], Error>
}


// MARK: - ExperienceService
final class ExperienceService: NSObject {
    // MARK: - properties
    private let firestoreService: FirestoreService
    
    
    // MARK: - init
    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }
}

// MARK: - logic
extension ExperienceService: ExperienceServicing {
    func fetchAll() async throws -> [Experience] {
        try await firestoreService.getAll(collection: .experiences,
                                          as: Experience.self)
    }
    
    func upsert(_ experience: Experience) async throws -> String {
        let documentId = experience.id ?? UUID().uuidString
        let payload = experience.withId(documentId)
        try await firestoreService.set(
            collection: .experiences,
            documentId: documentId,
            data: payload,
            merge: true
        )
        return documentId
    }
    
    func delete(id: String) async throws {
        try await firestoreService.delete(collection: .experiences, documentId: id)
    }
    
    func observeAll() -> AsyncThrowingStream<[Experience], Error> {
        firestoreService.listenToCollection(collection: .experiences, as: Experience.self)
    }
}

// MARK: - convertor
private extension Experience {
    func withId(_ newId: String) -> Experience {
        Experience(
            id: newId,
            description: description,
            fromDate: fromDate,
            toDate: toDate,
            role: role,
            skills: skills,
            title: title
        )
    }
}

