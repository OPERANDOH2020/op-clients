//
//  CNContactStore+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "JRSwizzle.h"
#import "InputSupervisorsManager.h"

@interface CNContactStore(rsHook)

@end


@implementation CNContactStore(rsHook)


+(void)load {
    if (NSClassFromString(@"CNContactStore")) {
        [self jr_swizzleMethod:@selector(requestAccessForEntityType:completionHandler:) withMethod:@selector(rsHook_requestAccessForEntityType:completionHandler:) error:nil];
    }
}

-(void)rsHook_requestAccessForEntityType:(CNEntityType)entityType completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler
{
    [[CNContactStore contactsInputSupervisor] processContactsAccess];
    [self rsHook_requestAccessForEntityType:entityType completionHandler:completionHandler];
}


+(ContactsInputSupervisor*)contactsInputSupervisor {
    return  [[InputSupervisorsManager sharedInstance] inputSupervisorOfType:[ContactsInputSupervisor class]];
}

@end
