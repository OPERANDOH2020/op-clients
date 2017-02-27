//
//  ACPrivacyWizard.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

enum ACPrivacyWizardState {
    case interrogation
    case recommendation
    case final
}

class ACPrivacyWizard: NSObject {
    
    // MARK: - Properties
    private var state: ACPrivacyWizardState = .interrogation
    private var currentRecommendation: AMPrivacyRecommendation?
    private(set) var currentSettings = [AMPrivacySetting]()
    var privacySettings: AMPrivacySettings?
    var recommendedParameters: AMRecommendedSettings?
    
    // MARK: - Lifecycle
    private override init() {
        super.init()
    }
    
    // MARK: - Shared Instance
    class var shared : ACPrivacyWizard {
        struct Singleton {
            static let instance = ACPrivacyWizard()
        }
        return Singleton.instance
    }
    
    // MARK: - Private Methods
    private func getCurrentChosenOptions() -> [Int] {
        var result = [Int]()
        
        for setting in currentSettings {
            if let selectedOption = setting.selectedOption {
                result.append(selectedOption)
            }
        }
        
        return result
    }
    
    private func getPrivacySettingsSuggestions() -> [AMPrivacySetting] {
        guard let previousSetting = currentSettings.last,
            let selectedOption = previousSetting.selectedOption,
            let currentRecommendation = currentRecommendation,
            let possibleChoicesIds = currentRecommendation.possibleChoicesIds,
            let possibleSuggestions = currentRecommendation.suggestions
            else { return [] }
        
        var suggestions = [Int]()
        
        if let selectedOptionIndex = possibleChoicesIds.index(of: selectedOption) {
            if possibleSuggestions.count > selectedOptionIndex {
                suggestions = possibleSuggestions[selectedOptionIndex]
            }
        }
        
        var result = [AMPrivacySetting]()
        if let lastSetting = currentSettings.last {
            result.append(lastSetting)
        }
        
        for suggestion in suggestions {
            if let privacySetting = privacySettings?.mappedPrivacySettings?[suggestion] {
                privacySetting.selectOption(withIndex: suggestion)
                result.append(privacySetting)
            }
        }
        
        currentSettings.removeLast()
        currentSettings.append(contentsOf: result)
        
        return result
    }
    
    private func retrieveQuestionAndSuggestions(completionHandler: @escaping (_ privacySettings: [AMPrivacySetting], _ state: ACPrivacyWizardState) -> Void) {
        JSPrivacyWizardContext.getNextQuestionAndSuggestions(selectedOptions: getCurrentChosenOptions(), completionHandler: { [weak self] (data) in
            guard let strongSelf = self else { return }
            strongSelf.currentRecommendation = AMPrivacyRecommendation(dictionary: data as! [String : Any])
            if let currentRecommendation = strongSelf.currentRecommendation, let privacySettings = strongSelf.privacySettings, let setting = privacySettings.getPrivacySetting(withId: currentRecommendation.questionId) {
                strongSelf.currentSettings.append(setting)
                completionHandler([setting], .interrogation)
            } else {
                strongSelf.state = .final
                completionHandler(strongSelf.currentSettings, .final)
            }
        })
    }
    
    // MARK: - Public Methods
    func setup() {
        ACSwarmManager.shared.loginWithUsername(username: "a", password: "aaaa") { (error, _) in
            ACSwarmManager.shared.getOSPSettings(completionHandler: { [weak self] (error, settings) in
                if let strongSelf = self {
                    DispatchQueue.main.async {
                        strongSelf.privacySettings = settings
                    }
                }
                ACSwarmManager.shared.getOSPSettingsRecommendedParameters(completionHandler: { [weak self] (error, recSettings) in
                    if let strongSelf = self {
                        DispatchQueue.main.async {
                            strongSelf.recommendedParameters = recSettings
                        }
                    }
                })
            })
        }
    }
    
    func reset() {
        state = .interrogation
        currentSettings = []
        currentRecommendation = nil
    }
    
    func getPrivacySettings(completion: @escaping (_ privacySettings: [AMPrivacySetting], _ state: ACPrivacyWizardState) -> Void) {
        switch state {
        case .interrogation:
            retrieveQuestionAndSuggestions(completionHandler: { (privacySettings, state) in
                completion(privacySettings, state)
            })
        case .recommendation:
            completion(getPrivacySettingsSuggestions(), .recommendation)
        case .final:
            completion([], .final)
        }
        
        if state != .final {
            state = state == .interrogation ? .recommendation : .interrogation
        }
    }
}
