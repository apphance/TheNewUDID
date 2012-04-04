#import <Foundation/Foundation.h>

extern NSString *const TNUUniqueKeychainAttributeServiceIdentifier;

@interface TNUAppSpecificUDID : NSObject

@property(nonatomic, retain) NSDictionary *baseQuery;

+ (id)appSpecificUUID;

- (NSString *)applicationUDID;
- (void)clearUDID;

@end
