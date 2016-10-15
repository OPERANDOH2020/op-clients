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
