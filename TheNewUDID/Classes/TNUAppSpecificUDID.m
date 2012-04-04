#import "TNUAppSpecificUDID.h"
#import <Security/Security.h>

@implementation TNUAppSpecificUDID {

@private
    NSDictionary *_baseQuery;
}
@synthesize baseQuery = _baseQuery;

NSString *const TNUUniqueKeychainAttributeServiceIdentifier = @"TNUUniqueKeychainAttributeServiceIdentifier";

+ (id)appSpecificUUID {
    return [[[self alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *keys = [NSArray arrayWithObjects:(id) kSecClass, (id) kSecAttrService, nil];
        NSArray *objects = [NSArray arrayWithObjects:(id)kSecClassGenericPassword, TNUUniqueKeychainAttributeServiceIdentifier, nil];

        self.baseQuery = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    }

    return self;
}

- (void)dealloc {
    [_baseQuery release];
    [super dealloc];
}

- (void)clearUDID {
    SecItemDelete([self baseQuery]);
}

- (NSData *)generateNewUDID {
    const CFUUIDRef cfUUID = CFUUIDCreate(NULL);
    NSString *stringRepresentation = CFUUIDCreateString(NULL, cfUUID);
    CFRelease(cfUUID);
    return [stringRepresentation dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)writeDataToKeychain:(NSData *)data {
    NSMutableDictionary *dictionary = [[[self baseQuery] mutableCopy] autorelease];
    [dictionary setObject:data forKey:(id)kSecValueData];

    SecItemAdd((CFDictionaryRef)dictionary, NULL);
}

- (NSString *)applicationUDID {
    NSData *data = nil;
    NSMutableDictionary *const dictionary = [[[self baseQuery] mutableCopy] autorelease];
    [dictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) dictionary, (CFTypeRef *) &data);

    if (status == errSecItemNotFound) {
        data = [self generateNewUDID];
        [self writeDataToKeychain:data];
    }
    NSString *const applicationUDID = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return applicationUDID;
}

@end
