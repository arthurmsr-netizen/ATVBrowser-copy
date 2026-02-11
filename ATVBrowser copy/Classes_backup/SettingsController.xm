#import <Foundation/Foundation.h>

%subclass SettingsController : BRMediaMenuController

static char const * const menuItemsKey = "menuItems";

- (id)init {
    if((self = %orig) != nil) {
        NSLog(@"Browser: SettingsController init");
        
        [self setListTitle:@"Browser Settings"];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:@"Set Homepage to Google"];
        [items addObject:@"Set Homepage to DuckDuckGo"];
        [items addObject:@"Set Homepage to Bing"];
        [items addObject:@"Reset to Defaults"];
        
        objc_setAssociatedObject(self, menuItemsKey, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [items release];
        
        [[self list] setDatasource:self];
        
        return self;
    }
    return self;
}

%new - (id)menuItems {
    return objc_getAssociatedObject(self, menuItemsKey);
}

%new - (void)setMenuItems:(id)items {
    objc_setAssociatedObject(self, menuItemsKey, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (long)itemCount {
    return [[self menuItems] count];
}

- (id)itemForRow:(long)row {
    return [[self menuItems] objectAtIndex:row];
}

- (id)titleForRow:(long)row {
    return [[self menuItems] objectAtIndex:row];
}

- (float)heightForRow:(long)row {
    return 0.0f;
}

- (BOOL)rowSelectable:(long)row {
    return YES;
}

- (id)previewControlForItem:(long)item {
    id theImage = [[%c(BRThemeInfo) sharedTheme] gearImage];
    id obj = [[%c(BRIconPreviewController) alloc] init];
    [obj setImage:theImage];
    return [obj autorelease];
}

- (void)itemSelected:(long)selected {
    NSLog(@"Browser: Settings item selected: %ld", (long)selected);
    
    Class managerClass = NSClassFromString(@"UserProfileManager");
    id manager = [managerClass sharedManager];
    
    switch(selected) {
        case 0:
            [manager setHomepage:@"https://www.google.com"];
            NSLog(@"Browser: Homepage set to Google");
            break;
        case 1:
            [manager setHomepage:@"https://duckduckgo.com"];
            NSLog(@"Browser: Homepage set to DuckDuckGo");
            break;
        case 2:
            [manager setHomepage:@"https://www.bing.com"];
            NSLog(@"Browser: Homepage set to Bing");
            break;
        case 3:
            [manager resetToDefaults];
            NSLog(@"Browser: Settings reset to defaults");
            break;
    }
    
    // Pop back to main menu after selection
    [[self stack] popController];
}

%end
