import Foundation
import Combine
import BaseModule
import ServiceModule


final class IntroductionVM: BaseViewModel {
    // MARK: - properties
    // state
    @Published private(set) var experienceState: ViewModelState = .init()
    @Published private(set) var introductionState: ViewModelState = .init()
    /// a general variable (one save at a time)
    @Published private(set) var saving: Bool = false
    
    // data
    @Published private(set) var experiences: [ExperienceItem] = []
    @Published private(set) var introduction: UserIntroduction?
    
    
    // services
    private let experienceService: ExperienceServicing
    private let introductionService: IntroductionServiceProtocol
    
    // tasks
    private var experienceTask: Task<Void, Never>?
    private var introductionTask: Task<Void, Never>?
    
    // MARK: - init
    init(experienceService: ExperienceServicing = ExperienceService(),
         introductionService: IntroductionServiceProtocol = IntroductionService()
    ) {
        self.introductionService = introductionService
        self.experienceService = experienceService
        super.init()
        observeExperiences()
        observeIntroduction()
        Logger.log(.function, level: .info, "initialized")
    }
    
    @MainActor
    deinit {
        introductionTask?.cancel()
        experienceTask?.cancel()
    }
    
    
    // MARK: - logics
    func refresh() {
        experienceTask?.cancel()
        introductionTask?.cancel()
        observeExperiences()
    }
}

// MARK: - Introduction logics
extension IntroductionVM {
    private func observeIntroduction() {
        @Injected var userManager: UserManager
        introductionState.loading = true
        guard let userId = userManager.userId else {
            Logger.log(.function, level: .error, "failed to get user id")
            toast = .init(type: .error, message: "Faild to get User Id")
            self.introductionState.error = CustomError(description: "Failed to get user Id")
            return }
        introductionTask = Task(name: "observe introduction") { [introductionService] in
            do {
                for try await record in introductionService.observeUser(userId: userId) {
                    await MainActor.run {
                        self.introduction = record
                        self.introductionState.loading = false
                    }
                }
            } catch {
                Logger.log(.function,
                           level: .error,
                           error.localizedDescription)
                await MainActor.run {
                    self.introductionState.loading = false
                    self.toast = .init(type: .error, message: "Failed to Observe Introduction")
                }
            }
        }
    }
}


// MARK: - experience logics
extension IntroductionVM {
    private func observeExperiences() {
        experienceState.loading = true
        experienceTask = Task { [experienceService] in
            do {
                for try await records in experienceService.observeAll() {
                    let items = records.map(ExperienceItem.init)
                    await MainActor.run {
                        self.experiences = items
                        self.experienceState.loading = false
                    }
                }
            } catch {
                Logger.log(.function,
                           level: .error,
                           error.localizedDescription)
                await MainActor.run {
                    self.experienceState.loading = false
                    self.toast = .init(type: .error, message: "Experiences observation faield")
                }
            }
        }
    }
    
    // MARK: - Edit Experiences
    private func saveExperience(id: String?, input: ExperienceFormState) {
        self.saving = true
        Task { [experienceService] in
            do {
                let payload = input.toExperience(id: id)
                _ = try await experienceService.upsert(payload)
                await MainActor.run {
                    self.saving = false
                }
                Logger.log(.function, level: .info, "Experience saved")
            } catch {
                Logger.log(.function, level: .error, error.localizedDescription)
                await MainActor.run {
                    self.saving = false
                    self.toast = .init(type: .error, message: "Failed to save Expetience")
                }
            }
        }
    }
    
    func createExperience(input: ExperienceFormState) {
        saveExperience(id: nil, input: input)
    }
    
    func editExperience(id: String, input: ExperienceFormState) {
        saveExperience(id: id, input: input)
    }
}
