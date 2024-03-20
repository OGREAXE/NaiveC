#import "NCLocalEnumStore.h"
#import "UIKit/UIKit.h"

@implementation NCLocalEnumStore
+(id)enumForName:(NSString *)name {
   static NSDictionary *store = nil;
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    store = @{
        
        };
    });

    return store[name];
}
@end
