import Foundation
import FirebaseStorage
import BaseModule

#if canImport(UIKit)
import UIKit
#endif

/// Firebase Storage Service
public class FirebaseStorageService {
    private let storage: Storage
    
    public init(storage: Storage = FirebaseManager.shared.storage) {
        self.storage = storage
    }
    
    // MARK: - Upload Operations
    
    /// Upload data to Firebase Storage
    public func upload(
        data: Data,
        path: String,
        metadata: StorageMetadata? = nil
    ) async throws -> String {
        let storageRef = storage.reference().child(path)
        
        let _ = try await storageRef.putDataAsync(data, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    #if canImport(UIKit)
    /// Upload image to Firebase Storage
    public func uploadImage(
        _ image: UIImage,
        path: String,
        compressionQuality: CGFloat = 0.8
    ) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw StorageError.invalidImage
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        return try await upload(data: imageData, path: path, metadata: metadata)
    }
    #endif
    
    /// Upload file from URL to Firebase Storage
    public func uploadFile(
        from fileURL: URL,
        to path: String,
        metadata: StorageMetadata? = nil
    ) async throws -> String {
        let storageRef = storage.reference().child(path)
        
        let _ = try await storageRef.putFileAsync(from: fileURL, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    // MARK: - Download Operations
    
    /// Download data from Firebase Storage
    public func download(path: String, maxSize: Int64 = 10 * 1024 * 1024) async throws -> Data {
        let storageRef = storage.reference().child(path)
        let data = try await storageRef.data(maxSize: maxSize)
        return data
    }
    
    #if canImport(UIKit)
    /// Download image from Firebase Storage
    public func downloadImage(path: String) async throws -> UIImage {
        let data = try await download(path: path)
        
        guard let image = UIImage(data: data) else {
            throw StorageError.invalidImage
        }
        
        return image
    }
    #endif
    
    /// Download file to local URL
    public func downloadFile(path: String, to localURL: URL) async throws {
        let storageRef = storage.reference().child(path)
        let _ = try await storageRef.write(toFile: localURL)
    }
    
    // MARK: - Metadata Operations
    
    /// Get download URL for a file
    public func getDownloadURL(path: String) async throws -> URL {
        let storageRef = storage.reference().child(path)
        return try await storageRef.downloadURL()
    }
    
    /// Get metadata for a file
    public func getMetadata(path: String) async throws -> StorageMetadata {
        let storageRef = storage.reference().child(path)
        return try await storageRef.getMetadata()
    }
    
    /// Update metadata for a file
    public func updateMetadata(path: String, metadata: StorageMetadata) async throws -> StorageMetadata {
        let storageRef = storage.reference().child(path)
        return try await storageRef.updateMetadata(metadata)
    }
    
    // MARK: - Delete Operations
    
    /// Delete a file from Firebase Storage
    public func delete(path: String) async throws {
        let storageRef = storage.reference().child(path)
        try await storageRef.delete()
    }
    
    // MARK: - List Operations
    
    /// List all items in a path
    public func listAll(path: String) async throws -> (items: [StorageReference], prefixes: [StorageReference]) {
        let storageRef = storage.reference().child(path)
        let result = try await storageRef.listAll()
        return (result.items, result.prefixes)
    }
    
    /// List items with pagination
    public func list(path: String, maxResults: Int64 = 100) async throws -> StorageListResult {
        let storageRef = storage.reference().child(path)
        return try await storageRef.list(maxResults: maxResults)
    }
}

// MARK: - Storage Errors

public enum StorageError: LocalizedError {
    case invalidImage
    case fileNotFound
    case uploadFailed
    case downloadFailed
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image data"
        case .fileNotFound:
            return "File not found"
        case .uploadFailed:
            return "Failed to upload file"
        case .downloadFailed:
            return "Failed to download file"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

