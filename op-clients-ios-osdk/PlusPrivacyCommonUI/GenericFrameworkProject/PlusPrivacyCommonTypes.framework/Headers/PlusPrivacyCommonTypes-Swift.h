// Generated by Apple Swift version 3.1 (swiftlang-802.0.48 clang-802.0.38)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if defined(__has_attribute) && __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes14BaseStringEnum")
@interface BaseStringEnum : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull rawValue;
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic, readonly) NSUInteger hash;
@property (nonatomic, readonly) NSInteger hashValue;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes19AccessFrequencyType")
@interface AccessFrequencyType : BaseStringEnum
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull SingularSampleRawValue;)
+ (NSString * _Nonnull)SingularSampleRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ContinuousRawValue;)
+ (NSString * _Nonnull)ContinuousRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ContinuousIntervalsRawValue;)
+ (NSString * _Nonnull)ContinuousIntervalsRawValue SWIFT_WARN_UNUSED_RESULT;
+ (AccessFrequencyType * _Nullable)createFromRawValue:(NSString * _Nonnull)rawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) AccessFrequencyType * _Nonnull Continuous;)
+ (AccessFrequencyType * _Nonnull)Continuous SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) AccessFrequencyType * _Nonnull SingularSample;)
+ (AccessFrequencyType * _Nonnull)SingularSample SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) AccessFrequencyType * _Nonnull ContinuousIntervals;)
+ (AccessFrequencyType * _Nonnull)ContinuousIntervals SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSDictionary<AccessFrequencyType *, NSString *> * _Nonnull accessFrequenciesDescriptions;)
+ (NSDictionary<AccessFrequencyType *, NSString *> * _Nonnull)accessFrequenciesDescriptions SWIFT_WARN_UNUSED_RESULT;
@end

@class InputType;
@class PrivacyDescription;

SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes13AccessedInput")
@interface AccessedInput : NSObject
@property (nonatomic, readonly, strong) InputType * _Nonnull inputType;
@property (nonatomic, readonly, strong) PrivacyDescription * _Nonnull privacyDescription;
@property (nonatomic, readonly, strong) AccessFrequencyType * _Nonnull accessFrequency;
@property (nonatomic, readonly) BOOL userControl;
- (nullable instancetype)initWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict OBJC_DESIGNATED_INITIALIZER;
+ (NSArray<AccessedInput *> * _Nullable)buildFromJsonArray:(NSArray<NSDictionary<NSString *, id> *> * _Nonnull)array SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end



@interface NSBundle (SWIFT_EXTENSION(PlusPrivacyCommonTypes))
@end

@class SCDDocument;
@class NSError;

SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes17CommonTypeBuilder")
@interface CommonTypeBuilder : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) CommonTypeBuilder * _Nonnull sharedInstance;)
+ (CommonTypeBuilder * _Nonnull)sharedInstance SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)buildSCDDocumentWith:(NSDictionary<NSString *, id> * _Nonnull)json in:(void (^ _Nullable)(SCDDocument * _Nullable, NSError * _Nullable))completion;
- (void)buildFromJSONWithArray:(NSArray<NSDictionary<NSString *, id> *> * _Nonnull)array completion:(void (^ _Nullable)(NSArray<SCDDocument *> * _Nullable, NSError * _Nullable))completion;
@end


SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes9InputType")
@interface InputType : BaseStringEnum
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull LocationRawValue;)
+ (NSString * _Nonnull)LocationRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull MicrophoneRawValue;)
+ (NSString * _Nonnull)MicrophoneRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull CameraRawValue;)
+ (NSString * _Nonnull)CameraRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull GyroscopeRawValue;)
+ (NSString * _Nonnull)GyroscopeRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull AccelerometerRawValue;)
+ (NSString * _Nonnull)AccelerometerRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ProximityRawValue;)
+ (NSString * _Nonnull)ProximityRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull TouchIDRawValue;)
+ (NSString * _Nonnull)TouchIDRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull BarometerRawValue;)
+ (NSString * _Nonnull)BarometerRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ForceRawValue;)
+ (NSString * _Nonnull)ForceRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull PedometerRawValue;)
+ (NSString * _Nonnull)PedometerRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull MagnetometerRawValue;)
+ (NSString * _Nonnull)MagnetometerRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ContactsRawValue;)
+ (NSString * _Nonnull)ContactsRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull BatteryRawValue;)
+ (NSString * _Nonnull)BatteryRawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Location;)
+ (InputType * _Nonnull)Location SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Microphone;)
+ (InputType * _Nonnull)Microphone SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Camera;)
+ (InputType * _Nonnull)Camera SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Gyroscope;)
+ (InputType * _Nonnull)Gyroscope SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Accelerometer;)
+ (InputType * _Nonnull)Accelerometer SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Proximity;)
+ (InputType * _Nonnull)Proximity SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull TouchID;)
+ (InputType * _Nonnull)TouchID SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Barometer;)
+ (InputType * _Nonnull)Barometer SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Force;)
+ (InputType * _Nonnull)Force SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Pedometer;)
+ (InputType * _Nonnull)Pedometer SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Magnetometer;)
+ (InputType * _Nonnull)Magnetometer SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Contacts;)
+ (InputType * _Nonnull)Contacts SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) InputType * _Nonnull Battery;)
+ (InputType * _Nonnull)Battery SWIFT_WARN_UNUSED_RESULT;
+ (InputType * _Nullable)createFromRawValue:(NSString * _Nonnull)rawValue SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSDictionary<InputType *, NSString *> * _Nonnull namesPerInputType;)
+ (NSDictionary<InputType *, NSString *> * _Nonnull)namesPerInputType SWIFT_WARN_UNUSED_RESULT;
@end


@interface NSError (SWIFT_EXTENSION(PlusPrivacyCommonTypes))
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull LocalSchemaProviderDomain;)
+ (NSString * _Nonnull)LocalSchemaProviderDomain SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NSError * _Nonnull jsonSchemaNotFound;)
+ (NSError * _Nonnull)jsonSchemaNotFound SWIFT_WARN_UNUSED_RESULT;
@end


@interface NSError (SWIFT_EXTENSION(PlusPrivacyCommonTypes))
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull SchemaValidatorDomain;)
+ (NSString * _Nonnull)SchemaValidatorDomain SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NSError * _Nonnull jsonNotValidAccordingToSchema;)
+ (NSError * _Nonnull)jsonNotValidAccordingToSchema SWIFT_WARN_UNUSED_RESULT;
@end


@interface NSError (SWIFT_EXTENSION(PlusPrivacyCommonTypes))
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull CommonTypeBuilderDomain;)
+ (NSString * _Nonnull)CommonTypeBuilderDomain SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NSError * _Nonnull schemaUnavailable;)
+ (NSError * _Nonnull)schemaUnavailable SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) NSError * _Nonnull unknownCommonTypeError;)
+ (NSError * _Nonnull)unknownCommonTypeError SWIFT_WARN_UNUSED_RESULT;
@end

enum PrivacyLevelType : NSInteger;
@class ThirdParty;

SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes18PrivacyDescription")
@interface PrivacyDescription : NSObject
@property (nonatomic, readonly) enum PrivacyLevelType privacyLevel;
@property (nonatomic, readonly, copy) NSArray<ThirdParty *> * _Nonnull thirdParties;
- (nullable instancetype)initWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

typedef SWIFT_ENUM(NSInteger, PrivacyLevelType) {
  PrivacyLevelTypeLocalOnly = 1,
  PrivacyLevelTypeAggregateOnly = 2,
  PrivacyLevelTypeDPCompatible = 3,
  PrivacyLevelTypeSelfUseOnly = 4,
  PrivacyLevelTypeSharedWithThirdParty = 5,
  PrivacyLevelTypeUnspecified = 6,
};


SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes11SCDDocument")
@interface SCDDocument : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull appTitle;
@property (nonatomic, readonly, copy) NSString * _Nonnull bundleId;
@property (nonatomic, readonly, copy) NSString * _Nullable appIconURL;
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nonnull accessedLinks;
@property (nonatomic, readonly, copy) NSArray<AccessedInput *> * _Nonnull accessedInputs;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC22PlusPrivacyCommonTypes10ThirdParty")
@interface ThirdParty : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
@property (nonatomic, readonly, copy) NSString * _Nonnull url;
- (nullable instancetype)initWithDict:(NSDictionary<NSString *, id> * _Nonnull)dict OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

#pragma clang diagnostic pop
