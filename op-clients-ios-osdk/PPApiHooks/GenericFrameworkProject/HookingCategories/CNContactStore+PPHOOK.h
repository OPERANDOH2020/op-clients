//
//  CNContactStore+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "NSObject+AutoSwizzle.h"

 #import "PPEventDispatcher+Internal.h"

@interface CNContactStore(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end

