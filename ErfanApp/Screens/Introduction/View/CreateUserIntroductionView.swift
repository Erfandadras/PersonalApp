//
//  CreateUserIntroductionView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/26/25.
//

import BaseModule
import SwiftUI
import PhotosUI

struct CreateUserIntroductionView: View {
    // MARK: - properties
    @StateObject private var viewModel: UpdateIntroductionVM
    @State private var selectedItem: PhotosPickerItem? = nil
    @Environment(\.dismiss) private var dismiss
    @State var model: UserIntroduction
    @State var selectedImage: UIImage?
    private let updating: Bool
    
    // MARK: - init
    init(_ model: UserIntroduction? = nil) {
        self.updating = model != nil
        self.model = model ?? .init(firstName: "",
                                    lastName: "",
                                    email: "",
                                    phone: "",
                                    title: "")
        _viewModel = .init(wrappedValue: .init())
    }
    
    // MARK: - view
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color.black.ignoresSafeArea()
            
            LinearGradient(
                colors: [Color.blue.opacity(0.15), .clear, Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    header
                    
                    avatarSection
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            sectionTitle("Identity")
                            CustomField(title: "First Name", text: $model.firstName, icon: "person.fill", placeholder: "John")
                            CustomField(title: "Last Name", text: $model.lastName, icon: "person.text.rectangle.fill", placeholder: "Doe")
                            CustomField(title: "Professional Title", text: $model.title, icon: "briefcase.fill", placeholder: "ex: iOS Developer")
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            sectionTitle("Contact Details")
                            CustomField(title: "Email Address", text: $model.email, icon: "envelope.fill", placeholder: "john@doe.com")
                                .keyboardType(.emailAddress)
                            CustomField(title: "Phone Number", text: $model.phone, icon: "phone.fill", placeholder: "+1234567890")
                                .keyboardType(.phonePad)
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            sectionTitle("Presence")
                            CustomField(title: "LinkedIn URL", text: .init(get: { model.linkedin ?? "" },
                                                                           set: { value in model.linkedin = value}),
                                        icon: "link", placeholder: "linkedin.com/in/...")
                            CustomField(title: "Instagram", text: .init(get: { model.instagram ?? "" },
                                                                                 set: { value in model.instagram = value}),
                                        icon: "camera.fill", placeholder: "instagram.com/...")
                            CustomField(title: "GitHub URL", text: .init(get: { model.github ?? "" },
                                                                         set: { value in model.github = value}),
                                        icon: "terminal.fill", placeholder: "github.com/...")
                        }
                    }
                    .padding(.horizontal, 24)
                }.padding(.bottom, 80)
            }
            
            saveButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .toast(toast: $viewModel.toast)
        .preferredColorScheme(.dark)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                    }
                }
            }
        }
    }
    
    // MARK: - Components
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(updating ? "Update Profile" : "Create Profile")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Share your professional journey with the world")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.1)))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var avatarSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else if let url = model.getAvatarURL(),
                              let image = UIImage(contentsOfFile: url.path) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.white.opacity(0.3))
                        }
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 4))
                .shadow(color: .blue.opacity(0.2), radius: 15, x: 0, y: 10)
                
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }
                .offset(x: -2, y: -2)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 13, weight: .bold, design: .monospaced))
            .foregroundStyle(.blue.opacity(0.8))
    }
    
    private var saveButton: some View {
        Button {
            Task(name: "Create Introduction") {
                let success = await viewModel.saveUserIntroduction(model: model, with: selectedImage)
                if success {
                    waitMainThread(after: 1.5) {
                        dismiss()
                    }
                }
            }
        } label: {
            HStack(spacing: 12) {
                if viewModel.modelState.loading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text( updating ? "Save Changes" : "Create Profile")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [.blue, .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 24)
        .disabled(viewModel.modelState.loading)
        .opacity(viewModel.modelState.loading ? 0.7 : 1)
    }
}

// MARK: - Custom Field
fileprivate struct CustomField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 38, height: 38)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(.blue.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}
