//
//  PrivacyForBenefitsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol PrivacyForBenefitsRepository
{
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?)
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    
}

//guard let serviceId = dict["serviceId"] as? Int,
//    let subscribed = dict["subscribed"] as? Bool else {
//        return nil
//}
//self.serviceId = serviceId
//self.subscribed = subscribed
//
//self.benefit = dict["benefit"] as? String
//self.description = dict["description"] as? String
//self.logo = dict["logo"] as? String
//self.voucher = dict["voucher"] as? String
//self.website = dict["website"] as? String
//self.identitifer = dict["identifier"] as? String

class DummyPfbRepository: PrivacyForBenefitsRepository
{
    
    let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse nec viverra augue. Mauris malesuada orci urna, sit amet sodales elit suscipit at. Vivamus eget sapien fermentum quam facilisis commodo sed ac erat. Donec sed sapien enim. Sed eget est ac orci posuere tincidunt. Duis consequat, massa id posuere blandit, ligula ex interdum nisl, eu facilisis lacus magna sed odio. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc pharetra lacus posuere fermentum imperdiet. Aenean venenatis sit amet dolor eu pretium. Quisque purus tellus, porttitor a ante sit amet, malesuada lacinia metus.\nInterdum et malesuada fames ac ante ipsum primis in faucibus. Ut molestie eros a nibh dignissim dignissim. Donec fermentum purus felis, dapibus consectetur velit auctor eget. Maecenas mauris orci, dapibus eget tincidunt a, ultricies congue lectus. Aliquam vestibulum justo quis metus vestibulum, sed pharetra nisi varius. Ut feugiat auctor elit vitae rhoncus. Sed justo elit, dictum nec lorem sit amet, egestas semper ipsum. Fusce malesuada eleifend velit, ullamcorper fringilla elit viverra eget. Quisque volutpat venenatis enim a facilisis. Nullam sit amet suscipit quam."
    
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?){
        
        var deals: [PfbDeal] = []
        
        deals.append(PfbDeal(dict: ["serviceId": 1,
                                        "subscribed": false,
                                        "benefit": "\(1) euros",
                                         "description": loremIpsum,
                                         "voucher": "\(1) -------- \(1)",
                                         "logo": "https://maxcdn.icons8.com/Share/icon/androidL/Logos//9gag1600.png",
                                         "website": "https://www.9gag.com"])!)
        
        
        let fbDeal = PfbDeal(dict: ["serviceId": 2,
                                    "subscribed": true,
                                    "benefit": "\(2) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.facebook.com"])!
        
        fbDeal.imageName = "fb";
        deals.append(fbDeal)
        
        let googleDeal = PfbDeal(dict: ["serviceId": 3,
                                    "subscribed": true,
                                    "benefit": "\(3) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.google.com"])!
        
        googleDeal.imageName = "googlePlus";
        deals.append(googleDeal)
        
        let yt = PfbDeal(dict: ["serviceId": 4,
                                    "subscribed": true,
                                    "benefit": "\(2) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.youtube.com"])!
       
        yt.imageName = "youtube"
        deals.append(yt)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion?(deals, nil)
        }
        
    }
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?(PfbDealUpdate(voucher: "555-call-me", subscribed: true), nil)
        }
        
    }
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion?(PfbDealUpdate(voucher: nil, subscribed: false), nil)
        }
    }
}
