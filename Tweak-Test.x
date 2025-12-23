#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface SBIconController : UIViewController
- (void)presentSpotlightAnimated:(BOOL)animated;
- (void)presentLibraryAnimated:(BOOL)animated completion:(id)completion;
@end

@interface SPUISearchViewController : UIViewController
@end

// Hook ALL Spotlight entry points
%hook SBIconController

- (void)presentSpotlightAnimated:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] CAUGHT IT! presentSpotlightAnimated");
    
    // Call App Library instead
    if ([self respondsToSelector:@selector(presentLibraryAnimated:completion:)]) {
        NSLog(@"[AppLibrarySwipe] Opening App Library");
        [self presentLibraryAnimated:animated completion:nil];
    } else {
        NSLog(@"[AppLibrarySwipe] presentLibraryAnimated not available, calling original");
        %orig;
    }
}

%end

// Hook Spotlight view controller directly
%hook SPUISearchViewController

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] Spotlight is trying to appear - BLOCKED");
    // Don't call %orig - this prevents Spotlight from showing
}

%end
