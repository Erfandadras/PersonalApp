//
//  FirebaseStreamProducer.swift
//  Pirelly
//
//  Created by Erfan mac mini on 12/6/25.
//

import FirebaseDatabase

final class FirebaseStreamProducer<Value: Decodable> {

    private var continuation: AsyncThrowingStream<Value, Error>.Continuation?
    private var handle: DatabaseHandle?
    private var isTerminated = false

    private let ref: DatabaseReference
    private let path: String

    init(ref: DatabaseReference, path: String) {
        self.ref = ref
        self.path = path
    }

    func start() -> AsyncThrowingStream<Value, Error> {
        return AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.handle = self.ref.child(self.path).observe(.value) { snapshot in
                guard let value = snapshot.value else {
                    return
                }
                do {
                    let parsed = try self.parseData(data: value)
                    continuation.yield(parsed)
                } catch {
                    continuation.finish(throwing: error)
                    self.clean()
                }
            }

            continuation.onTermination = { _ in
                self.clean()
            }
        }
    }

    private func clean() {
        guard !isTerminated else { return }
        isTerminated = true

        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }

        continuation = nil
    }
    
    private func parseData(data: Any) throws -> Value {
        guard let dict = data as? Dictionary<String, Any> else {
            throw FirebaseRTDBError.valueError
        }
        let data = try JSONSerialization.data(withJSONObject: dict)
        return try data.decode()
    }
}
