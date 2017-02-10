//
//  ViolationReportCell.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ViolationReportCell.h"

@interface ViolationReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViolationReportCell

+(NSString *)identifierNibName {
    return @"ViolationReportCell";
}

-(void)setupWithReport:(OPMonitorViolationReport *)report {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    self.messageLabel.text = report.violationDetails;
    self.dateLabel.text = [dateFormatter stringFromDate:report.dateReported];
    
}

@end
