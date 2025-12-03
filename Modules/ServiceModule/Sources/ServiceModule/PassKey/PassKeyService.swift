import Foundation
import AuthenticationServices
import BaseModule

/// PassKey Authentication Service using WebAuthn/FIDO2
@MainActor
public class PassKeyService: NSObject {
    
    // MARK: - Properties
    private var authenticationAnchor: ASPresentationAnchor?
    private var continuation: CheckedContinuation<PassKeyCredential, Error>?
    
    // MARK: - Public Methods
    
    /// Sign in with PassKey
    /// - Parameter anchor: The window to present the PassKey UI
    /// - Returns: PassKey credential containing user information
    public func signInWithPassKey(anchor: ASPresentationAnchor) async throws -> PassKeyCredential {
        self.authenticationAnchor = anchor
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: PassKeyConfiguration.relyingPartyID
            )
            
            // Create assertion request for sign in
            let challenge = generateChallenge()
            let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challenge)
            
            let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
            authController.delegate = self
            authController.presentationContextProvider = self
            authController.performRequests()
        }
    }
    
    /// Register a new PassKey
    /// - Parameters:
    ///   - userName: User's name
    ///   - userID: User's unique identifier
    ///   - anchor: The window to present the PassKey UI
    /// - Returns: PassKey credential containing registration information
    public func registerPassKey(userName: String, userID: String, anchor: ASPresentationAnchor) async throws -> PassKeyCredential {
        self.authenticationAnchor = anchor
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
                relyingPartyIdentifier: PassKeyConfiguration.relyingPartyID
            )
            
            // Create registration request
            let challenge = generateChallenge()
            let userIDData = Data(userID.utf8)
            
            let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(
                challenge: challenge,
                name: userName,
                userID: userIDData
            )
            
            let authController = ASAuthorizationController(authorizationRequests: [registrationRequest])
            authController.delegate = self
            authController.presentationContextProvider = self
            authController.performRequests()
        }
    }
    
    /// Check if PassKey is available on this device
    public static var isPassKeyAvailable: Bool {
        if #available(iOS 16.0, *) {
            return true
        }
        return false
    }
    
    // MARK: - Private Methods
    
    private func generateChallenge() -> Data {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension PassKeyService: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let platformKeyCredential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
            // Sign in flow
            let credential = PassKeyCredential(
                credentialID: platformKeyCredential.credentialID,
                userID: platformKeyCredential.userID,
                signature: platformKeyCredential.signature,
                authenticatorData: platformKeyCredential.rawAuthenticatorData,
                isRegistration: false
            )
            continuation?.resume(returning: credential)
            continuation = nil
            
        } else if let platformKeyCredential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
            // Registration flow
            let credential = PassKeyCredential(
                credentialID: platformKeyCredential.credentialID,
                userID: Data(),
                signature: Data(),
                authenticatorData: Data(),
                isRegistration: true,
                attestationObject: platformKeyCredential.rawAttestationObject
            )
            continuation?.resume(returning: credential)
            continuation = nil
            
        } else {
            continuation?.resume(throwing: PassKeyError.invalidCredential)
            continuation = nil
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Logger.log(.function, level: .error, "PassKey Authorization Failed", error.localizedDescription)
        
        let authError = error as? ASAuthorizationError
        
        switch authError?.code {
        case .canceled:
            continuation?.resume(throwing: PassKeyError.userCanceled)
        case .failed:
            continuation?.resume(throwing: PassKeyError.authenticationFailed)
        case .notHandled:
            continuation?.resume(throwing: PassKeyError.notHandled)
        default:
            continuation?.resume(throwing: PassKeyError.unknown(error))
        }
        
        continuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension PassKeyService: ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return authenticationAnchor ?? ASPresentationAnchor()
    }
}

// MARK: - PassKey Configuration
public enum PassKeyConfiguration {
    /// Your app's relying party identifier (usually your domain)
    /// For development, you can use your bundle identifier
    public static var relyingPartyID: String {
        return Bundle.main.bundleIdentifier ?? "ios.erfan-dadras.com.ErfanApp"
    }
}

// MARK: - PassKey Credential Model
public struct PassKeyCredential {
    public let credentialID: Data
    public let userID: Data
    public let signature: Data
    public let authenticatorData: Data
    public let isRegistration: Bool
    public let attestationObject: Data?
    
    public init(
        credentialID: Data,
        userID: Data,
        signature: Data,
        authenticatorData: Data,
        isRegistration: Bool,
        attestationObject: Data? = nil
    ) {
        self.credentialID = credentialID
        self.userID = userID
        self.signature = signature
        self.authenticatorData = authenticatorData
        self.isRegistration = isRegistration
        self.attestationObject = attestationObject
    }
}

// MARK: - PassKey Errors
public enum PassKeyError: LocalizedError {
    case userCanceled
    case authenticationFailed
    case notHandled
    case invalidCredential
    case notAvailable
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .userCanceled:
            return "PassKey authentication was canceled"
        case .authenticationFailed:
            return "PassKey authentication failed"
        case .notHandled:
            return "PassKey request was not handled"
        case .invalidCredential:
            return "Invalid PassKey credential"
        case .notAvailable:
            return "PassKey is not available on this device"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
