#import "BackRowExtras.h"
#import <Foundation/Foundation.h>

#define TOPSHELFVIEW %c(BRTopShelfView)
#define BRAPPCAT %c(BRApplianceCategory)
#define BROWSER_ID @"browserWeb"
#define BROWSER_CAT [BRAPPCAT categoryWithName:@"Browser" identifier:BROWSER_ID preferredOrder:0]

%subclass BrowserApplianceInfo : BRApplianceInfo

- (NSString*)key {
    return [[[NSBundle bundleForClass:[self class]] infoDictionary] 
            objectForKey:(NSString*)kCFBundleIdentifierKey];
}

- (NSString*)name {
    return [[[NSBundle bundleForClass:[self class]] localizedInfoDictionary] 
            objectForKey:(NSString*)kCFBundleNameKey];
}

- (id)localizedStringsFileName {
    return @"BrowserLocalizable";
}

%end

@interface TopShelfController : NSObject {
}
- (void)refresh;
- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
@end

@implementation TopShelfController

-(void)refresh {
}

- (void)selectCategoryWithIdentifier:(id)identifier {
}

- (id)topShelfView {
    id topShelf = [[TOPSHELFVIEW alloc] init];
    return topShelf;
}

@end

%subclass BrowserAppliance : BRBaseAppliance

static char const * const topShelfControllerKey = "topShelfController";
static char const * const applianceCategoriesKey = "applianceCategories";

- (id)applianceInfo {
    Class cls = objc_getClass("BrowserApplianceInfo");
    NSLog(@"Browser: applianceInfo cls: %@", cls);
    return [[[cls alloc] init] autorelease];
}

+ (void)initialize {
    NSLog(@"Browser: Appliance initialized");
}

- (id)init {
    if((self = %orig) != nil) {
        TopShelfController *topShelfControl = [[TopShelfController alloc] init];
        objc_setAssociatedObject(self, topShelfControllerKey, topShelfControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [topShelfControl release];
        
        NSArray *categoryArray = [NSArray arrayWithObjects:BROWSER_CAT, nil];
        objc_setAssociatedObject(self, applianceCategoriesKey, categoryArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"Browser: Appliance initialized successfully");
    }
    return self;
}

%new - (id)topShelfController {
    return objc_getAssociatedObject(self, topShelfControllerKey);
}

%new - (id)applianceCategories {
    return objc_getAssociatedObject(self, applianceCategoriesKey);
}

%new - (id)identifierForContentAlias:(id)contentAlias {
    return BROWSER_ID;
}

%new - (id)controllerForIdentifier:(id)identifier args:(id)args {
    NSLog(@"Browser: controllerForIdentifier: %@ args: %@", identifier, args);
    
    if ([identifier isEqualToString:BROWSER_ID]) {
        Class browserController = objc_getClass("BrowserMainController");
        id controller = [[browserController alloc] init];
        return [controller autorelease];
    }
    return nil;
}

%new - (BOOL)handlePlay {
    return NO;
}

%end
