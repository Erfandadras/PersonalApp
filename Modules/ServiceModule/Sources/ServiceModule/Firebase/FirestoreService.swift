import Foundation
import FirebaseFirestore
import BaseModule

/// Firebase Firestore Database Service
public class FirestoreService {
    private let db: Firestore
    
    public init(db: Firestore = FirebaseManager.shared.firestore) {
        self.db = db
    }
    
    // MARK: - Generic CRUD Operations
    
    /// Create a document with auto-generated ID
    public func create<T: Encodable>(
        collection: String,
        data: T
    ) async throws -> String {
        let docRef = try db.collection(collection).addDocument(from: data)
        return docRef.documentID
    }
    
    /// Create or update a document with specific ID
    public func set<T: Encodable>(
        collection: String,
        documentId: String,
        data: T,
        merge: Bool = true
    ) async throws {
        try db.collection(collection)
            .document(documentId)
            .setData(from: data, merge: merge)
    }
    
    /// Read a document
    public func get<T: Decodable>(
        collection: String,
        documentId: String,
        as type: T.Type
    ) async throws -> T {
        let document = try await db.collection(collection)
            .document(documentId)
            .getDocument()
        
        guard let data = try? document.data(as: type) else {
            throw FirestoreError.decodingFailed
        }
        
        return data
    }
    
    /// Update specific fields in a document
    public func update(
        collection: String,
        documentId: String,
        fields: [String: Any]
    ) async throws {
        try await db.collection(collection)
            .document(documentId)
            .updateData(fields)
    }
    
    /// Delete a document
    public func delete(
        collection: String,
        documentId: String
    ) async throws {
        try await db.collection(collection)
            .document(documentId)
            .delete()
    }
    
    // MARK: - Query Operations
    
    /// Get all documents in a collection
    public func getAll<T: Decodable>(
        collection: String,
        as type: T.Type
    ) async throws -> [T] {
        let snapshot = try await db.collection(collection).getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: type)
        }
    }
    
    /// Query documents with where clause
    public func query<T: Decodable>(
        collection: String,
        field: String,
        isEqualTo value: Any,
        as type: T.Type
    ) async throws -> [T] {
        let snapshot = try await db.collection(collection)
            .whereField(field, isEqualTo: value)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: type)
        }
    }
    
    /// Query documents with ordering and limit
    public func queryOrdered<T: Decodable>(
        collection: String,
        orderBy field: String,
        descending: Bool = false,
        limit: Int? = nil,
        as type: T.Type
    ) async throws -> [T] {
        var query: Query = db.collection(collection)
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
        collection: String,
        documentId: String,
        as type: T.Type,
        onUpdate: @escaping (Result<T, Error>) -> Void
    ) -> ListenerRegistration {
        return db.collection(collection)
            .document(documentId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    onUpdate(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot,
                      let data = try? snapshot.data(as: type) else {
                    onUpdate(.failure(FirestoreError.decodingFailed))
                    return
                }
                
                onUpdate(.success(data))
            }
    }
    
    /// Listen to a collection in real-time
    public func listenToCollection<T: Decodable>(
        collection: String,
        as type: T.Type,
        onUpdate: @escaping (Result<[T], Error>) -> Void
    ) -> ListenerRegistration {
        return db.collection(collection)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    onUpdate(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot else {
                    onUpdate(.failure(FirestoreError.snapshotFailed))
                    return
                }
                
                let documents = snapshot.documents.compactMap { document in
                    try? document.data(as: type)
                }
                
                onUpdate(.success(documents))
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

public enum FirestoreError: LocalizedError {
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

