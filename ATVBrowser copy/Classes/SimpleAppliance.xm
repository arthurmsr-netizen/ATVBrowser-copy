#import <Foundation/Foundation.h>

void LogToFile(NSString *msg) {
    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:@"/var/mobile/simpleapp.log"];
    if (fh) {
        [fh seekToEndOfFile];
        [fh writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
    } else {
        [msg writeToFile:@"/var/mobile/simpleapp.log" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}

@interface SimpleMenuController : NSObject
@end

@implementation SimpleMenuController

- (id)init {
    LogToFile(@"[SimpleMenuController init]\n");
    
    Class BRMediaMenuController = NSClassFromString(@"BRMediaMenuController");
    if (BRMediaMenuController) {
        self = [[BRMediaMenuController alloc] init];
        if (self && [self respondsToSelector:@selector(setListTitle:)]) {
            [self performSelector:@selector(setListTitle:) withObject:@"Simple Browser"];
            LogToFile(@"[Menu controller created]\n");
        }
    }
    return self;
}

@end

%subclass SimpleAppliance : BRBaseAppliance

+ (void)load {
    LogToFile(@"[LOAD]\n");
}

- (id)initWithApplianceInfo:(id)applianceInfo {
    LogToFile(@"[initWithApplianceInfo]\n");
    
    if ((self = %orig)) {
        LogToFile(@"[INIT] Success\n");
    }
    
    return self;
}

- (id)applianceCategories {
    LogToFile(@"[applianceCategories]\n");
    return [NSArray array];
}

- (id)initialController {
    LogToFile(@"[initialController]\n");
    
    SimpleMenuController *controller = [[SimpleMenuController alloc] init];
    if (controller) {
        LogToFile(@"[Returning controller]\n");
        return [controller autorelease];
    }
    
    LogToFile(@"[No controller created]\n");
    return nil;
}

- (id)controllerForIdentifier:(id)identifier args:(id)args {
    LogToFile([NSString stringWithFormat:@"[controllerForIdentifier:%@]\n", identifier]);
    return [self initialController];
}

- (id)identifierForContentAlias:(id)alias {
    LogToFile([NSString stringWithFormat:@"[identifierForContentAlias:%@]\n", alias]);
    return @"main";
}

- (id)topShelfController {
    LogToFile(@"[topShelfController]\n");
    return nil;
}

- (void)selectCategoryWithIdentifier:(id)identifier {
    LogToFile([NSString stringWithFormat:@"[selectCategoryWithIdentifier:%@]\n", identifier]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    LogToFile([NSString stringWithFormat:@"[UNKNOWN:%@]\n", NSStringFromSelector(aSelector)]);
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    LogToFile([NSString stringWithFormat:@"[FORWARD:%@]\n", NSStringFromSelector([invocation selector])]);
}

- (BOOL)brEventAction:(id)action {
    LogToFile([NSString stringWithFormat:@"[brEventAction:%@]\n", action]);
    return %orig;
}

%end
