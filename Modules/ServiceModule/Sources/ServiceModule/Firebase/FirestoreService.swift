import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import BaseModule

public enum FirestoreCollection: String, CaseIterable, Sendable {
    case experiences = "Experiences"
    case users = "User"
    
    var path: String { rawValue }
}

/// Firebase Firestore Database Service
public final class FirestoreService {
    private let db: Firestore
    
    public init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    private func collectionRef(for collection: FirestoreCollection) -> CollectionReference {
        db.collection(collection.path)
    }
    
    // MARK: - Generic CRUD Operations
    
    /// Create a document with auto-generated ID
    public func create<T: Encodable>(
        collection: FirestoreCollection,
        data: T
    ) async throws -> String {
        let docRef = try collectionRef(for: collection).addDocument(from: data)
        return docRef.documentID
    }
    
    /// Create or update a document with specific ID
    public func set<T: Encodable>(
        collection: FirestoreCollection,
        documentId: String,
        data: T,
        merge: Bool = true
    ) async throws {
        try collectionRef(for: collection)
            .document(documentId)
            .setData(from: data, merge: merge)
    }
    
    /// Read a document
    public func get<T: Decodable>(
        collection: FirestoreCollection,
        documentId: String,
        as type: T.Type
    ) async throws -> T {
        let document = try await collectionRef(for: collection)
            .document(documentId)
            .getDocument()
        
        guard document.exists else {
            throw FirestoreError.documentNotFound
        }
        
        do {
            return try document.data(as: type)
        } catch {
            throw FirestoreError.decodingFailed
        }
    }
    
    /// Update specific fields in a document
    public func update(
        collection: FirestoreCollection,
        documentId: String,
        fields: [String: Any]
    ) async throws {
        try await collectionRef(for: collection)
            .document(documentId)
            .updateData(fields)
    }
    
    /// Delete a document
    public func delete(
        collection: FirestoreCollection,
        documentId: String
    ) async throws {
        try await collectionRef(for: collection)
            .document(documentId)
            .delete()
    }
    
    // MARK: - Query Operations
    
    /// Get all documents in a collection
    public func getAll<T: Decodable>(
        collection: FirestoreCollection,
        as type: T.Type
    ) async throws -> [T] {
        let snapshot = try await collectionRef(for: collection).getDocuments()
        return snapshot.documents.compactMap { document in
            return try? document.data(as: type)
        }
    }
    
    /// Query documents with where clause
    public func query<T: Decodable>(
        collection: FirestoreCollection,
        field: String,
        isEqualTo value: Any,
        as type: T.Type
    ) async throws -> [T] {
        let snapshot = try await collectionRef(for: collection)
            .whereField(field, isEqualTo: value)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: type)
        }
    }
    
    /// Query documents with ordering and limit
    public func queryOrdered<T: Decodable>(
        collection: FirestoreCollection,
        orderBy field: String,
        descending: Bool = false,
        limit: Int? = nil,
        as type: T.Type
    ) async throws -> [T] {
        var query: Query = collectionRef(for: collection)
            .order(by: field, descending: descending)
        
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        let snapshot = try await query.getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: type)
        }
    }
    
    // MARK: - Real-time Listeners
    
    /// Listen to a document in real-time
    public func listen<T: Decodable>(
        collection: FirestoreCollection,
        documentId: String,
        as type: T.Type
    ) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            let listener = collectionRef(for: collection)
                .document(documentId)
                .addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: error)
                        return
                    }
                    
                    guard let snapshot = snapshot, snapshot.exists else {
                        continuation.finish(throwing: FirestoreError.documentNotFound)
                        return
                    }
                    
                    do {
                        let data = try snapshot.data(as: type)
                        continuation.yield(data)
                    } catch {
                        continuation.finish(throwing: FirestoreError.decodingFailed)
                    }
                }
            
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    /// Listen to a collection in real-time
    public func listenToCollection<T: Decodable>(
        collection: FirestoreCollection,
        as type: T.Type
    ) -> AsyncThrowingStream<[T], Error> {
        AsyncThrowingStream { continuation in
            let listener = collectionRef(for: collection)
                .addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: error)
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        continuation.finish(throwing: FirestoreError.snapshotFailed)
                        return
                    }
                    
                    let documents: [T] = snapshot.documents.compactMap { document in
                        try? document.data(as: type)
                    }
                    
                    continuation.yield(documents)
                }
            
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    // MARK: - Batch Operations
    
    /// Perform batch write operations
    public func batch(_ operations: (WriteBatch) -> Void) async throws {
        let batch = db.batch()
        operations(batch)
        try await batch.commit()
    }
}

// MARK: - Firestore Errors

public enum FirestoreError: LocalizedError, Equatable {
    case documentNotFound
    case decodingFailed
    case encodingFailed
    case snapshotFailed
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "Document not found"
        case .decodingFailed:
            return "Failed to decode document"
        case .encodingFailed:
            return "Failed to encode data"
        case .snapshotFailed:
            return "Failed to get snapshot"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

public extension FirestoreError {
    static func == (lhs: FirestoreError, rhs: FirestoreError) -> Bool {
        switch (lhs, rhs) {
        case (.documentNotFound, .documentNotFound),
            (.decodingFailed, .decodingFailed),
            (.encodingFailed, .encodingFailed),
            (.snapshotFailed, .snapshotFailed):
            return true
        case (.unknown, .unknown):
            return false
        default:
            return false
        }
    }
}

