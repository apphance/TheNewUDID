/*
Copyright (c) 2012 Apphance (www.apphance.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

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
    SecItemDelete((CFDictionaryRef)[self baseQuery]);
}

- (NSData *)generateUDID {
    const CFUUIDRef cfUUID = CFUUIDCreate(NULL);
    NSString *stringRepresentation = [(NSString*)CFUUIDCreateString(NULL, cfUUID) autorelease];
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
        data = [self generateUDID];
        [self writeDataToKeychain:data];
    }
    NSString *const applicationUDID = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return applicationUDID;
}

@end
