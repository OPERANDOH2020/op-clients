//
//  ACPrivacyWriter.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class ACPrivacyWriter: NSObject {

    static func createJsonString(fromPrivacySettings settings: [AMPrivacySetting]) -> String? {
        var array = [Dictionary<String, Any>]()
        
        for setting in settings {
            if let mappedSetting = map(privacySetting: setting) {
                array.append(mappedSetting)
            }
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            return result as String?
        } catch {
            return nil
        }
    }
    
    static func map(privacySetting setting: AMPrivacySetting) -> Dictionary<String, Any>? {
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let page = write.page,
            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName)
        else { return nil }
        
        var result = Dictionary<String, Any>()
        
        result["name"] = selectedSettingName
        result["page"] = page
        result["url"] = urlTemplate
        result["data"] = write.data
        
        
        return result
    }
}
