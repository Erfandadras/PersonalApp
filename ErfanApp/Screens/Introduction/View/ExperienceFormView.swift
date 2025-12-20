//
//  ExperienceFormView.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/16/25.
//

import SwiftUI
import BaseModule


private struct FlexibleSkillTags: View {
    let skills: [String]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
            ForEach(skills, id: \.self) { skill in
                Text(skill)
                    .font(.ui.sRegular)
                    .foregroundColor(.ui.textPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.ui.gray1)
                    )
            }
        }
    }
}

private enum ExperienceFormMode {
    case create
    case edit
    
    var title: String {
        switch self {
        case .create: return "Add Experience"
        case .edit: return "Edit Experience"
        }
    }
}

private struct ExperienceFormView: View {
    let mode: ExperienceFormMode
    let onSave: (ExperienceFormState) -> Void
    
    @State private var form: ExperienceFormState
    @Environment(\.dismiss) private var dismiss
    
    init(mode: ExperienceFormMode, initial: ExperienceFormState? = nil, onSave: @escaping (ExperienceFormState) -> Void) {
        self.mode = mode
        self.onSave = onSave
        _form = State(initialValue: initial ?? ExperienceFormState())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details").font(.ui.largSemiBold)) {
                    TextField("Title", text: $form.title)
                    TextField("Role", text: $form.role)
                    TextField("Description", text: $form.description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Dates").font(.ui.largSemiBold)) {
                    TextField("From (timestamp)", text: $form.fromDate)
                        .keyboardType(.numberPad)
                    TextField("To (timestamp, optional)", text: $form.toDate)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Skills (comma separated)").font(.ui.largSemiBold)) {
                    TextField("e.g. Swift, SwiftUI, Firebase", text: $form.skillsText)
                }
            }
            .navigationTitle(mode.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(form)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
    
    private var canSave: Bool {
        !form.title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !form.role.trimmingCharacters(in: .whitespaces).isEmpty &&
        !form.description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !form.fromDate.trimmingCharacters(in: .whitespaces).isEmpty
    }
}



private struct ExperienceCardView: View {
    let experience: ExperienceItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(experience.title)
                        .font(.ui.xlargSemiBold)
                        .foregroundColor(.ui.textPrimary)
                    Text(experience.role)
                        .font(.ui.mRegular)
                        .foregroundColor(.ui.textSecondary)
                }
                Spacer()
                Text(experience.dateRangeText)
                    .font(.ui.sSemiBold)
                    .foregroundColor(.ui.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.ui.gray1)
                    )
            }
            
            Text(experience.description)
                .font(.ui.bodyRegular)
                .foregroundColor(.ui.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            if !experience.skills.isEmpty {
                FlexibleSkillTags(skills: experience.skills)
            }
        }
        .padding(16)
        .background(Color.ui.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.ui.border, lineWidth: 1)
        )
        .shadow(color: Color.ui.shadowColor, radius: 6, x: 0, y: 3)
    }
}
