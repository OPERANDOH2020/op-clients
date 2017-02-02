//
//  ContactsInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ContactsInputSupervisor.h"
#import <Contacts/Contacts.h>


@interface CNContactStore(rsHook)

@end


@implementation CNContactStore(rsHook)


-(void)rsHook_requestAccessForEntityType:(CNEntityType)entityType completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler
{
    
    [self rsHook_requestAccessForEntityType:entityType completionHandler:completionHandler];
}

@end


@interface ContactsInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *contactsSource;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@end

@implementation ContactsInputSupervisor


-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    self.delegate = delegate;
    self.document = document;
    
    //MUST RENAME IN THE SELF-COMPLIANCE SCHEMA
    // AND COMMON TYPES TO "InputSource" from "AccessedSensor"
}

@end
