#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%subclass BrowserWebViewController : BRController

static char const * const webViewKey = "webView";
static char const * const currentURLKey = "currentURL";

- (id)init {
    if((self = %orig) != nil) {
        NSLog(@"Browser: WebViewController initializing");
        return self;
    }
    return self;
}

- (void)loadView {
    %orig;
    
    NSLog(@"Browser: Loading web view");
    
    CGRect frame = CGRectMake(0, 0, 1280, 720);
    
    UIWebView *webView = [[NSClassFromString(@"UIWebView") alloc] initWithFrame:frame];
    
    if (webView) {
        webView.backgroundColor = [UIColor whiteColor];
        webView.scalesPageToFit = YES;
        webView.delegate = (id<UIWebViewDelegate>)self;
        
        NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
        NSLog(@"Browser: Adding webview to view hierarchy");
        [[self view] addSubview:webView];
        
        objc_setAssociatedObject(self, webViewKey, webView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [webView release];
    } else {
        NSLog(@"Browser: ERROR - Failed to create UIWebView!");
    }
}

%new - (UIWebView*)webView {
    return objc_getAssociatedObject(self, webViewKey);
}

%new - (void)setCurrentURL:(NSString*)url {
    objc_setAssociatedObject(self, currentURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new - (NSString*)currentURL {
    return objc_getAssociatedObject(self, currentURLKey);
}

%new - (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Browser: Page started loading");
}

%new - (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Browser: Page finished loading");
    NSString *url = [webView.request.URL absoluteString];
    [self setCurrentURL:url];
    NSLog(@"Browser: Current URL: %@", url);
}

%new - (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Browser: Load failed with error: %@", [error localizedDescription]);
}

- (void)dealloc {
    UIWebView *webView = [self webView];
    if (webView) {
        webView.delegate = nil;
        [webView stopLoading];
        [webView removeFromSuperview];
    }
    %orig;
}

%end
