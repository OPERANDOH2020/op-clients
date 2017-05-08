//
//  HookURLProtocol.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "Common.h"
#import "PPEventDispatcher+Internal.h"

@interface HookURLProtocol : NSURLProtocol
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);

@end
