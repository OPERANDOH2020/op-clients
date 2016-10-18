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
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    
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
        for i in 1...15 {
            deals.append(PfbDeal(dict: ["serviceId": i,
                                        "subscribed": i % 3 == 0,
                                        "benefit": "\(i) euros",
                                         "description": loremIpsum,
                                         "voucher": "\(i) -------- \(i)",
                                         "logo": "http://www.brandsoftheworld.com/sites/default/files/styles/logo-thumbnail/public/122010/etsy-thumb.png",
                                         "website": "http://www.google.ro"])!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { 
            completion?(deals, nil)
        }
        
    }
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { 
            completion?(true, nil)
        }
        
    }
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion?(true, nil)
        }
    }
}
