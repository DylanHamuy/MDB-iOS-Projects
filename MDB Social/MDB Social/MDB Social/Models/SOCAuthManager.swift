//
//  AuthManager.swift
//  MDB Social No Starter
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SOCAuthManager {
    
    static let shared = SOCAuthManager()
    
    let auth = Auth.auth()
    
    enum SignInErrors: Error {
        case wrongPassword
        case userNotFound
        case invalidEmail
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
        case unspecified
    }
    
    enum SignUpErrors: Error {
        case emailAlreadyInUse
        case invalidEmail
        case weakPassword
        case operationNotAllowed
        case unspecified
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
    }
    
    let db = Firestore.firestore()
    
    var currentUser: SOCUser?
    
    private var userListener: ListenerRegistration?
    
    init() {
        guard let user = auth.currentUser else { return }
        
        linkUser(withuid: user.uid, completion: nil)
    }
    
    func signIn(withEmail email: String, password: String,
                completion: ((Result<SOCUser, SignInErrors>)->Void)?) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .wrongPassword:
                    completion?(.failure(.wrongPassword))
                case .userNotFound:
                    completion?(.failure(.userNotFound))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            
            self?.linkUser(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    /* TODO: Firebase sign up handler, add user to firestore */
    
    func signUp(withEmail email: String, password: String, fullName: String, username: String,
                completion: ((Result<SOCUser, SignUpErrors>)->Void)?) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .emailAlreadyInUse:
                    completion?(.failure(.emailAlreadyInUse))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                case .weakPassword:
                    completion?(.failure(.weakPassword))
                case .operationNotAllowed:
                    completion?(.failure(.operationNotAllowed))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            let currentUser = SOCUser(uid: authResult.user.uid, username: username, email: email, fullname: fullName, savedEvents: [])
            
            
            FIRDatabaseRequest.shared.setUser(currentUser, completion: nil)
            
            self?.linkUserSignUp(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func signOut(completion: (()->Void)? = nil) {
        do {
            try auth.signOut()
            unlinkCurrentUser()
            completion?()
        } catch { }
    }
    
    private func linkUser(withuid uid: String,
                          completion: ((Result<SOCUser, SignInErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: SOCUser.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    private func linkUserSignUp(withuid uid: String,
                          completion: ((Result<SOCUser, SignUpErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: SOCUser.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    
    private func unlinkCurrentUser() {
        userListener?.remove()
        currentUser = nil
    }
}
