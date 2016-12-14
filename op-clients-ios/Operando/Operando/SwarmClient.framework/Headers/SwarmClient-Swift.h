// Generated by Apple Swift version 3.0.1 (swiftlang-800.0.58.6 clang-800.0.42.1)
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
#if defined(__has_feature) && __has_feature(modules)
@import Foundation;
@import ObjectiveC;
@import Security;
@import Security.CipherSuite;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

@interface NSArray (SWIFT_EXTENSION(SwarmClient))
@end


@interface NSData (SWIFT_EXTENSION(SwarmClient))
@end


@interface NSDictionary (SWIFT_EXTENSION(SwarmClient))
@end


@interface NSDictionary (SWIFT_EXTENSION(SwarmClient))
@end


@interface NSNull (SWIFT_EXTENSION(SwarmClient))
@end


@interface NSString (SWIFT_EXTENSION(SwarmClient))
@end


SWIFT_CLASS("_TtC11SwarmClient7SSLCert")
@interface SSLCert : NSObject
/**
  Designated init for certificates
  \param data is the binary data of the certificate


  returns:
  a representation security object to be used with
*/
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
/**
  Designated init for public keys
  \param key is the public key to be used


  returns:
  a representation security object to be used with
*/
- (nonnull instancetype)initWithKey:(SecKeyRef _Nonnull)key OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC11SwarmClient11SSLSecurity")
@interface SSLSecurity : NSObject
@property (nonatomic) BOOL validatedDN;
/**
  Use certs from main app bundle
  \param usePublicKeys is to specific if the publicKeys or certificates should be used for SSL pinning validation


  returns:
  a representation security object to be used with
*/
- (nonnull instancetype)initWithUsePublicKeys:(BOOL)usePublicKeys;
/**
  Designated init
  \param keys is the certificates or public keys to use

  \param usePublicKeys is to specific if the publicKeys or certificates should be used for SSL pinning validation


  returns:
  a representation security object to be used with
*/
- (nonnull instancetype)initWithCerts:(NSArray<SSLCert *> * _Nonnull)certs usePublicKeys:(BOOL)usePublicKeys OBJC_DESIGNATED_INITIALIZER;
/**
  Valid the trust and domain name.
  \param trust is the serverTrust to validate

  \param domain is the CN domain to validate


  returns:
  if the key was successfully validated
*/
- (BOOL)isValid:(SecTrustRef _Nonnull)trust domain:(NSString * _Nullable)domain;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC11SwarmClient16SocketAckEmitter")
@interface SocketAckEmitter : NSObject
- (void)with:(NSArray * _Nonnull)items;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC11SwarmClient14SocketAnyEvent")
@interface SocketAnyEvent : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull event;
@property (nonatomic, readonly, copy) NSArray * _Nullable items;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class SocketIOClient;

/**
  Experimental socket manager.
  API subject to change.
  Can be used to persist sockets across ViewControllers.
  Sockets are strongly stored, so be sure to remove them once they are no
  longer needed.
  Example usage:
  \code
  let manager = SocketClientManager.sharedManager
  manager["room1"] = socket1
  manager["room2"] = socket2
  manager.removeSocket(socket: socket2)
  manager["room1"]?.emit("hello")

  \endcode*/
SWIFT_CLASS("_TtC11SwarmClient19SocketClientManager")
@interface SocketClientManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) SocketClientManager * _Nonnull sharedManager;)
+ (SocketClientManager * _Nonnull)sharedManager;
- (SocketIOClient * _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)string;
- (void)setObject:(SocketIOClient * _Nullable)socket forKeyedSubscript:(NSString * _Nonnull)string;
- (void)addSocket:(SocketIOClient * _Nonnull)socket labeledAs:(NSString * _Nonnull)label;
- (SocketIOClient * _Nullable)removeSocketWithLabel:(NSString * _Nonnull)label;
- (SocketIOClient * _Nullable)removeSocket:(SocketIOClient * _Nonnull)socket;
- (void)removeSockets;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class OS_dispatch_queue;
@class NSHTTPCookie;
@class NSURLSession;
@class WebSocket;
@protocol SocketEngineClient;
enum SocketEnginePacketType : NSInteger;
@class NSError;

SWIFT_CLASS("_TtC11SwarmClient12SocketEngine")
@interface SocketEngine : NSObject <NSURLSessionDelegate>
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull emitQueue;
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull handleQueue;
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull parseQueue;
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable connectParams;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull postWait;
@property (nonatomic) BOOL waitingForPoll;
@property (nonatomic) BOOL waitingForPost;
@property (nonatomic, readonly) BOOL closed;
@property (nonatomic, readonly) BOOL connected;
@property (nonatomic, readonly, copy) NSArray<NSHTTPCookie *> * _Nullable cookies;
@property (nonatomic, readonly) BOOL doubleEncodeUTF8;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable extraHeaders;
@property (nonatomic, readonly) BOOL fastUpgrade;
@property (nonatomic, readonly) BOOL forcePolling;
@property (nonatomic, readonly) BOOL forceWebsockets;
@property (nonatomic, readonly) BOOL invalidated;
@property (nonatomic, readonly) BOOL polling;
@property (nonatomic, readonly) BOOL probing;
@property (nonatomic, readonly, strong) NSURLSession * _Nullable session;
@property (nonatomic, readonly, copy) NSString * _Nonnull sid;
@property (nonatomic, readonly, copy) NSString * _Nonnull socketPath;
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlPolling;
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlWebSocket;
@property (nonatomic, readonly) BOOL websocket;
@property (nonatomic, readonly, strong) WebSocket * _Nullable ws;
@property (nonatomic, weak) id <SocketEngineClient> _Nullable client;
- (nonnull instancetype)initWithClient:(id <SocketEngineClient> _Nonnull)client url:(NSURL * _Nonnull)url options:(NSDictionary * _Nullable)options;
/**
  Starts the connection to the server
*/
- (void)connect;
- (void)didErrorWithReason:(NSString * _Nonnull)reason;
- (void)disconnectWithReason:(NSString * _Nonnull)reason;
- (void)doFastUpgrade;
- (void)flushWaitingForPostToWebSocket;
- (void)parseEngineData:(NSData * _Nonnull)data;
- (void)parseEngineMessage:(NSString * _Nonnull)message fromPolling:(BOOL)fromPolling;
/**
  Write a message, independent of transport.
*/
- (void)write:(NSString * _Nonnull)msg withType:(enum SocketEnginePacketType)type withData:(NSArray<NSData *> * _Nonnull)data;
- (void)websocketDidConnectWithSocket:(WebSocket * _Nonnull)socket;
- (void)websocketDidDisconnectWithSocket:(WebSocket * _Nonnull)socket error:(NSError * _Nullable)error;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface SocketEngine (SWIFT_EXTENSION(SwarmClient))
- (void)URLSessionWithSession:(NSURLSession * _Nonnull)session didBecomeInvalidWithError:(NSError * _Nullable)error;
@end


SWIFT_PROTOCOL("_TtP11SwarmClient18SocketEngineClient_")
@protocol SocketEngineClient
- (void)engineDidErrorWithReason:(NSString * _Nonnull)reason;
- (void)engineDidCloseWithReason:(NSString * _Nonnull)reason;
- (void)engineDidOpenWithReason:(NSString * _Nonnull)reason;
- (void)parseEngineMessage:(NSString * _Nonnull)msg;
- (void)parseEngineBinaryData:(NSData * _Nonnull)data;
@end

typedef SWIFT_ENUM(NSInteger, SocketEnginePacketType) {
  SocketEnginePacketTypeOpen = 0,
  SocketEnginePacketTypeClose = 1,
  SocketEnginePacketTypePing = 2,
  SocketEnginePacketTypePong = 3,
  SocketEnginePacketTypeMessage = 4,
  SocketEnginePacketTypeUpgrade = 5,
  SocketEnginePacketTypeNoop = 6,
};


SWIFT_PROTOCOL("_TtP11SwarmClient16SocketEngineSpec_")
@protocol SocketEngineSpec
@property (nonatomic, weak) id <SocketEngineClient> _Nullable client;
@property (nonatomic, readonly) BOOL closed;
@property (nonatomic, readonly) BOOL connected;
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable connectParams;
@property (nonatomic, readonly) BOOL doubleEncodeUTF8;
@property (nonatomic, readonly, copy) NSArray<NSHTTPCookie *> * _Nullable cookies;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable extraHeaders;
@property (nonatomic, readonly) BOOL fastUpgrade;
@property (nonatomic, readonly) BOOL forcePolling;
@property (nonatomic, readonly) BOOL forceWebsockets;
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull parseQueue;
@property (nonatomic, readonly) BOOL polling;
@property (nonatomic, readonly) BOOL probing;
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull emitQueue;
@property (nonatomic, readonly, strong) OS_dispatch_queue * _Nonnull handleQueue;
@property (nonatomic, readonly, copy) NSString * _Nonnull sid;
@property (nonatomic, readonly, copy) NSString * _Nonnull socketPath;
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlPolling;
@property (nonatomic, readonly, copy) NSURL * _Nonnull urlWebSocket;
@property (nonatomic, readonly) BOOL websocket;
@property (nonatomic, readonly, strong) WebSocket * _Nullable ws;
- (nonnull instancetype)initWithClient:(id <SocketEngineClient> _Nonnull)client url:(NSURL * _Nonnull)url options:(NSDictionary * _Nullable)options;
- (void)connect;
- (void)didErrorWithReason:(NSString * _Nonnull)reason;
- (void)disconnectWithReason:(NSString * _Nonnull)reason;
- (void)doFastUpgrade;
- (void)flushWaitingForPostToWebSocket;
- (void)parseEngineData:(NSData * _Nonnull)data;
- (void)parseEngineMessage:(NSString * _Nonnull)message fromPolling:(BOOL)fromPolling;
- (void)write:(NSString * _Nonnull)msg withType:(enum SocketEnginePacketType)type withData:(NSArray<NSData *> * _Nonnull)data;
@end

enum SocketIOClientStatus : NSInteger;
@class NSURL;

SWIFT_CLASS("_TtC11SwarmClient14SocketIOClient")
@interface SocketIOClient : NSObject <SocketEngineClient>
@property (nonatomic, readonly, copy) NSURL * _Nonnull socketURL;
@property (nonatomic, readonly, strong) id <SocketEngineSpec> _Nullable engine;
@property (nonatomic, readonly) enum SocketIOClientStatus status;
@property (nonatomic) BOOL forceNew;
@property (nonatomic, copy) NSString * _Nonnull nsp;
@property (nonatomic) BOOL reconnects;
@property (nonatomic) NSInteger reconnectWait;
@property (nonatomic, readonly, copy) NSString * _Nullable sid;
/**
  Not so type safe way to create a SocketIOClient, meant for Objective-C compatiblity.
  If using Swift it’s recommended to use \code
  init(socketURL: NSURL, options: Set<SocketIOClientOption>)
  \endcode
*/
- (nonnull instancetype)initWithSocketURL:(NSURL * _Nonnull)socketURL config:(NSDictionary * _Nullable)config;
/**
  Connect to the server.
*/
- (void)connect;
/**
  Connect to the server. If we aren’t connected after timeoutAfter, call withHandler
  0 Never times out
*/
- (void)connectWithTimeoutAfter:(NSInteger)timeoutAfter withHandler:(void (^ _Nullable)(void))handler;
/**
  Disconnects the socket.
*/
- (void)disconnect;
/**
  Same as emit, but meant for Objective-C
*/
- (void)emit:(NSString * _Nonnull)event with:(NSArray * _Nonnull)items;
/**
  Same as emitWithAck, but for Objective-C
*/
- (void (^ _Nonnull)(uint64_t, void (^ _Nonnull)(NSArray * _Nonnull)))emitWithAck:(NSString * _Nonnull)event with:(NSArray * _Nonnull)items;
- (void)engineDidCloseWithReason:(NSString * _Nonnull)reason;
/**
  error
*/
- (void)engineDidErrorWithReason:(NSString * _Nonnull)reason;
- (void)engineDidOpenWithReason:(NSString * _Nonnull)reason;
/**
  Causes an event to be handled. Only use if you know what you’re doing.
*/
- (void)handleEvent:(NSString * _Nonnull)event data:(NSArray * _Nonnull)data isInternalMessage:(BOOL)isInternalMessage withAck:(NSInteger)ack;
/**
  Leaves nsp and goes back to /
*/
- (void)leaveNamespace;
/**
  Joins namespace
*/
- (void)joinNamespace:(NSString * _Nonnull)namespace_;
/**
  Removes handler(s) based on name
*/
- (void)off:(NSString * _Nonnull)event;
/**
  Removes a handler with the specified UUID gotten from an \code
  on
  \endcode or \code
  once
  \endcode
*/
- (void)offWithId:(NSUUID * _Nonnull)id;
/**
  Adds a handler for an event.
  Returns: A unique id for the handler
*/
- (NSUUID * _Nonnull)on:(NSString * _Nonnull)event callback:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))callback;
/**
  Adds a single-use handler for an event.
  Returns: A unique id for the handler
*/
- (NSUUID * _Nonnull)once:(NSString * _Nonnull)event callback:(void (^ _Nonnull)(NSArray * _Nonnull, SocketAckEmitter * _Nonnull))callback;
/**
  Adds a handler that will be called on every event.
*/
- (void)onAny:(void (^ _Nonnull)(SocketAnyEvent * _Nonnull))handler;
- (void)parseEngineMessage:(NSString * _Nonnull)msg;
- (void)parseEngineBinaryData:(NSData * _Nonnull)data;
/**
  Tries to reconnect to the server.
*/
- (void)reconnect;
/**
  Removes all handlers.
  Can be used after disconnecting to break any potential remaining retain cycles.
*/
- (void)removeAllHandlers;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

/**
  <em>NotConnected</em>: initial state
  <em>Disconnected</em>: connected before
*/
typedef SWIFT_ENUM(NSInteger, SocketIOClientStatus) {
  SocketIOClientStatusNotConnected = 0,
  SocketIOClientStatusDisconnected = 1,
  SocketIOClientStatusConnecting = 2,
  SocketIOClientStatusConnected = 3,
};


SWIFT_CLASS("_TtC11SwarmClient11SwarmClient")
@interface SwarmClient : NSObject
- (nonnull instancetype)initWithConnectionURL:(NSString * _Nonnull)connectionURL OBJC_DESIGNATED_INITIALIZER;
- (void)startSwarm:(NSString * _Nonnull)swarmName phase:(NSString * _Nonnull)phase ctor:(NSString * _Nonnull)ctor arguments:(NSArray * _Nonnull)arguments;
- (void)disconnectAndReconnectWithCompletion:(void (^ _Nullable)(NSString * _Nullable))completion;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class NSStream;

SWIFT_CLASS("_TtC11SwarmClient9WebSocket")
@interface WebSocket : NSObject <NSStreamDelegate>
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ErrorDomain;)
+ (NSString * _Nonnull)ErrorDomain;
@property (nonatomic, strong) OS_dispatch_queue * _Nonnull callbackQueue;
@property (nonatomic, copy) void (^ _Nullable onConnect)(void);
@property (nonatomic, copy) void (^ _Nullable onDisconnect)(NSError * _Nullable);
@property (nonatomic, copy) void (^ _Nullable onText)(NSString * _Nonnull);
@property (nonatomic, copy) void (^ _Nullable onData)(NSData * _Nonnull);
@property (nonatomic, copy) void (^ _Nullable onPong)(NSData * _Nullable);
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull headers;
@property (nonatomic) BOOL voipEnabled;
@property (nonatomic) BOOL disableSSLCertValidation;
@property (nonatomic, strong) SSLSecurity * _Nullable security;
@property (nonatomic, copy) NSArray<NSNumber *> * _Nullable enabledSSLCipherSuites;
@property (nonatomic, copy) NSString * _Nullable origin;
@property (nonatomic) NSInteger timeout;
@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly, copy) NSURL * _Nonnull currentURL;
/**
  Used for setting protocols.
*/
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url protocols:(NSArray<NSString *> * _Nullable)protocols OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url writeQueueQOS:(NSQualityOfService)writeQueueQOS protocols:(NSArray<NSString *> * _Nullable)protocols;
/**
  Connect to the WebSocket server on a background thread.
*/
- (void)connect;
/**
  Write a string to the websocket. This sends it as a text frame.
  If you supply a non-nil completion block, I will perform it when the write completes.
  \param str The string to write.

  \param completion The (optional) completion handler.

*/
- (void)writeWithString:(NSString * _Nonnull)string completion:(void (^ _Nullable)(void))completion;
/**
  Write binary data to the websocket. This sends it as a binary frame.
  If you supply a non-nil completion block, I will perform it when the write completes.
  \param data The data to write.

  \param completion The (optional) completion handler.

*/
- (void)writeWithData:(NSData * _Nonnull)data completion:(void (^ _Nullable)(void))completion;
/**
  Write a ping to the websocket. This sends it as a control frame.
  Yodel a   sound  to the planet.    This sends it as an astroid. http://youtu.be/Eu5ZJELRiJ8?t=42s
*/
- (void)writeWithPing:(NSData * _Nonnull)ping completion:(void (^ _Nullable)(void))completion;
/**
  Delegate for the stream methods. Processes incoming bytes
*/
- (void)stream:(NSStream * _Nonnull)aStream handleEvent:(NSStreamEvent)eventCode;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

#pragma clang diagnostic pop
