#import <Cedar-iOS/SpecHelper.h>

#define EXP_SHORTHAND
#import "Expecta.h"

#import <Security/Security.h>
#import "TNUAppSpecificUDID.h"

SPEC_BEGIN(TNUAppSpecificUDIDSpec)

describe(@"TNUAppSpecificUDID", ^{
    __block TNUAppSpecificUDID *appSpecificUDID;

    beforeEach(^{
        appSpecificUDID = [TNUAppSpecificUDID appSpecificUUID];
    });

    describe(@"generting keychain query", ^{
        it(@"should set the sec class as password", ^{
            NSDictionary *queryDictionary = [appSpecificUDID baseQuery];
            id const secClass = [queryDictionary objectForKey:(id) kSecClass];

            expect(secClass).toEqual((id)kSecClassGenericPassword);
        });
        it(@"should set the attribute service to unique keychain identifier", ^{
            NSDictionary *queryDictionary = [appSpecificUDID baseQuery];
            id const secAttrService = [queryDictionary objectForKey:(id) kSecAttrService];

            expect(secAttrService).toEqual(TNUUniqueKeychainAttributeServiceIdentifier);
        });
    });

    describe(@"accessing UDID", ^{
        context(@"when there's not UDID present in keychain", ^{
            it(@"should generate a new UDID object", ^{
                NSString *appUDID = [appSpecificUDID applicationUDID];

                expect(appUDID).toBeKindOf([NSString class]);
            });
        });

        context(@"when there's a UDID present in keychain", ^{
            it(@"should not replace it with a new item", ^{
                NSMutableDictionary *query = [[[appSpecificUDID baseQuery] mutableCopy] autorelease];
                NSString *fakeUDID = @"Fixture UDID";
                [query setObject:[fakeUDID dataUsingEncoding:NSUTF8StringEncoding] forKey:(id) kSecValueData];
                SecItemAdd((CFDictionaryRef) query, NULL);

                NSString *const applicationUDID = [appSpecificUDID applicationUDID];

                expect(applicationUDID).toEqual(@"Fixture UDID");
            });
        });
    });

    describe(@"deleting UDID", ^{
        it(@"should remove the UDID from keychain", ^{
            //set a dummy keychain data object
            NSMutableDictionary *query = [[[appSpecificUDID baseQuery] mutableCopy] autorelease];
            NSString *fakeUDID = @"Fixture UDID";
            [query setObject:[fakeUDID dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
            SecItemAdd((CFDictionaryRef)query, NULL);

            [appSpecificUDID clearUDID];

            OSStatus status = SecItemCopyMatching([appSpecificUDID baseQuery], NULL);
            expect(status).toEqual(errSecItemNotFound);
        });
    });
});

SPEC_END
