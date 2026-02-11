#import <Foundation/Foundation.h>

// UserProfileManager - Singleton class to manage user preferences
@interface UserProfileManager : NSObject

+ (instancetype)sharedManager;
- (NSString*)getHomepage;
- (void)setHomepage:(NSString*)homepage;
- (void)resetToDefaults;

@end

@implementation UserProfileManager

static UserProfileManager *sharedInstance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init]) != nil) {
        NSLog(@"Browser: UserProfileManager initialized");
    }
    return self;
}

- (NSString*)getHomepage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *homepage = [defaults stringForKey:@"BrowserHomepage"];
    
    if (!homepage || [homepage length] == 0) {
        homepage = @"https://www.google.com";
    }
    
    NSLog(@"Browser: Getting homepage: %@", homepage);
    return homepage;
}

- (void)setHomepage:(NSString*)homepage {
    if (homepage && [homepage length] > 0) {
        // Validate URL format
        NSURL *url = [NSURL URLWithString:homepage];
        if (url && url.scheme && url.host) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:homepage forKey:@"BrowserHomepage"];
            [defaults synchronize];
            NSLog(@"Browser: Homepage set to: %@", homepage);
        } else {
            NSLog(@"Browser: Invalid URL format: %@", homepage);
        }
    }
}

- (void)resetToDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"BrowserHomepage"];
    [defaults synchronize];
    NSLog(@"Browser: User preferences reset to defaults");
}

@end
