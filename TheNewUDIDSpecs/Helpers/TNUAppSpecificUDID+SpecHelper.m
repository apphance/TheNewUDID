#import "TNUAppSpecificUDID+SpecHelper.h"


@implementation TNUAppSpecificUDID (SpecHelper)

+ (void)beforeEach {
    [[self appSpecificUUID] clearUDID];
}

@end
