//
//  MagnetometerInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

@interface MagnetometerInputSupervisor : NSObject <InputSourceSupervisor>
-(void)processMagnetometerStatus;
@end
