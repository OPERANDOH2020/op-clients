//
//  PlistReportsStorage.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PlistReportsStorage.h"
#import "Common.h"
#import "PPAccessUnlistedHostReport+NSDictionaryRepresentation.h"
#import "PPPrivacyLevelViolationReport+NSDictionaryRepresentation.h"
#import "PPUnlistedInputAccessViolation+NSDictionaryRepresentation.h"
#import "PPAccessFrequencyViolationReport+NSDictionaryRepresentation.h"




@interface PlistReportsStorage()

@property (strong, nonatomic) NSMutableArray<PPAccessFrequencyViolationReport*> *frequencyReportsArray;
@property (strong, nonatomic) NSMutableArray<PPAccessUnlistedHostReport*> *hostReportsArray;
@property (strong, nonatomic) NSMutableArray<PPPrivacyLevelViolationReport*> *privacyLevelReportsArray;
@property (strong, nonatomic) NSMutableArray<PPUnlistedInputAccessViolation*> *inputReportsArray;

@end

@implementation PlistReportsStorage

static NSString *kPlistReportStorageDomain = @"com.plistReportStorage";
static NSString *kIndexOutOfRangeDescription = @"Index is out of range";
static NSString *kObjectNotInRepository = @"Object is not in repository";

static NSString *kFrequencyRepository = @"kFrequencyRepository";
static NSString *kHostRepository = @"kHostRepository";
static NSString *kPrivacyLevelRepository = @"kPrivacyLevelRepository";
static NSString *kInputRepository = @"kInputRepository";

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


+(NSArray*)buildObjectsOfClass:(Class)class fromDictionaries:(NSArray<NSDictionary*>*)dictionaries {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in dictionaries) {
        id object = [[class alloc] initWithNSDictionary:dict];
        if (object) {
            [result addObject:object];
        }
    }
    
    return result;
}

+(NSArray<NSDictionary*>*)createDictionaryRepresentationsOfObjects:(NSArray<id<DictionaryRepresentable>>*)objects{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id<DictionaryRepresentable> repr in objects) {
        NSDictionary *dict = [repr dictionaryRepresentation];
        if (dict) {
            [result addObject:dict];
        }
    }
    
    return result;
    
}

#pragma mark - private methods


+(NSString*)plistPathForRepositoryName:(NSString*)repositoryName {
    if (repositoryName == nil) {
        return @"";
    }
    NSString *pathComponent = [NSString stringWithFormat:@"%@.plist", repositoryName];
    
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (paths.firstObject) {
        return [paths.firstObject stringByAppendingPathComponent:pathComponent];
    }
    
    
    return @"";
}

@end

