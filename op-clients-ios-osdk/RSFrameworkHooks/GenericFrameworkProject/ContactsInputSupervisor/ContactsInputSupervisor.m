//
//  ContactsInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ContactsInputSupervisor.h"
#import <Contacts/Contacts.h>
#import "CommonUtils.h"

@interface ContactsInputSupervisor()
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) AccessedInput *contactsSource;
@property (weak, nonatomic) id<InputSupervisorDelegate> delegate;
@end

@implementation ContactsInputSupervisor


-(void)reportToDelegate:(id<InputSupervisorDelegate>)delegate analyzingSCD:(SCDDocument *)document {
    self.delegate = delegate;
    self.document = document;
    self.contactsSource = [CommonUtils extractInputOfType:InputType.Contacts from:document.accessedInputs];
}


-(void)processContactsAccess {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.delegate newUnlistedInputAccessViolationReported:report];
    }
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.contactsSource) {
        return  nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Contacts dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
