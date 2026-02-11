#import <Foundation/Foundation.h>

%subclass BrowserMainController : BRMediaMenuController

static char const * const menuItemsKey = "menuItems";

- (id)init {
    if((self = %orig) != nil) {
        NSLog(@"Browser: BrowserMainController init");
        
        [self setListTitle:@"Web Browser"];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:@"Open Browser"];
        [items addObject:@"Bookmarks"];
        [items addObject:@"Settings"];
        
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
    id theImage = nil;
    
    switch (item) {
        case 0:
            theImage = [[%c(BRThemeInfo) sharedTheme] largeGeniusIconWithReflection];
            break;
        case 1:
            theImage = [[%c(BRThemeInfo) sharedTheme] networkPhotosImage];
            break;
        case 2:
            theImage = [[%c(BRThemeInfo) sharedTheme] gearImage];
            break;
    }
    
    id obj = [[%c(BRIconPreviewController) alloc] init];
    [obj setImage:theImage];
    return [obj autorelease];
}

- (void)itemSelected:(long)selected {
    NSLog(@"Browser: Item selected: %ld", (long)selected);
    
    switch(selected) {
        case 0: {
            Class webViewClass = objc_getClass("BrowserWebViewController");
            if (webViewClass) {
                id webViewController = [[webViewClass alloc] init];
                [[self stack] pushController:webViewController];
                [webViewController release];
            } else {
                NSLog(@"Browser: ERROR - WebViewController class not found!");
            }
            break;
        }
        case 1:
            NSLog(@"Browser: Bookmarks selected - coming soon");
            break;
        case 2: {
            Class settingsClass = objc_getClass("SettingsController");
            if (settingsClass) {
                id settingsController = [[settingsClass alloc] init];
                [[self stack] pushController:settingsController];
                [settingsController release];
            } else {
                NSLog(@"Browser: ERROR - SettingsController class not found!");
            }
            break;
        }
    }
}

%end
